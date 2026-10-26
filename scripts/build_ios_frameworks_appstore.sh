#!/usr/bin/env bash
# Release（真机 + 模拟器）xcframework 打包：
# - Flutter.xcframework：保留 Flutter 官方 Developer ID 签名
# - 其他 framework：内层 .framework / .bundle / xcframework 全部用 Distribution 签名
#   （必须签内层，只签 xcframework 外壳无法通过 ITMS-91065）
# 产物布局对齐 chumo_framework：Release/*.xcframework + GeneratedPluginRegistrant.*
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

# 钥匙串里可能有多张同名 Jaclyn 证书；用 SHA-1 指纹避免 ambiguous，并避开链不完整的那张
IDENTITY="${CODE_SIGN_IDENTITY:-9D5B519CB076965F8B29D046DB992EC8A40AC4EE}"
TEAM_ID="${TEAM_ID:-KNJ693MCA7}"
AUTHORITY_MATCH="${AUTHORITY_MATCH:-Jaclyn Kendra}"
FLUTTER_AUTHORITY_MATCH="${FLUTTER_AUTHORITY_MATCH:-FLUTTER.IO LLC}"
FLUTTER_TEAM_ID="${FLUTTER_TEAM_ID:-S8QB4VV633}"
OUTPUT_DIR="${OUTPUT_DIR:-build/ios/framework}"
RELEASE_DIR="$OUTPUT_DIR/Release"
# 最终交付目录（与 build/chumo_framework 同结构）
EXPORT_DIR="${EXPORT_DIR:-build/biyan_framework}"
P12_PATH="${P12_PATH:-}"
P12_PASSWORD="${P12_PASSWORD:-123}"
if [[ -z "$P12_PATH" ]]; then
  for cand in \
    "/Users/Admin/Desktop/白包/彼颜/白包/证书.p12" \
    "/Users/Admin/Desktop/白包/彼颜/证书.p12"; do
    if [[ -f "$cand" ]]; then
      P12_PATH="$cand"
      break
    fi
  done
fi
if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
else
  FLUTTER_BIN="${FLUTTER_BIN:-/Users/Admin/Desktop/flutter/bin/flutter}"
fi
VERSION="$(awk '/^version:/{print $2; exit}' pubspec.yaml)"
ZIP_NAME="biyan_ios_frameworks_${VERSION%%+*}_AppStore.zip"
DESKTOP_COPY="${DESKTOP_COPY:-/Users/Admin/Desktop/白包/彼颜/$ZIP_NAME}"

rm -rf "$RELEASE_DIR" "$EXPORT_DIR" "$OUTPUT_DIR"/Debug "$OUTPUT_DIR"/Profile "$OUTPUT_DIR"/AppStoreFrameworks "$OUTPUT_DIR"/chumo_style
rm -f "$OUTPUT_DIR/$ZIP_NAME"
mkdir -p "$(dirname "$EXPORT_DIR")"

"$FLUTTER_BIN" pub get
# --no-codesign：先保留 Flutter 引擎官方签名，再单独给其他 framework 签 iOS 证书
"$FLUTTER_BIN" build ios-framework \
  --release --no-profile --no-debug \
  --no-codesign \
  --output="$OUTPUT_DIR"

TMP_KEYCHAIN=""
ORIGINAL_KEYCHAINS="$(security list-keychains -d user | sed 's/"//g' | tr '\n' ' ')"
cleanup_tmp_keychain() {
  if [[ -n "$ORIGINAL_KEYCHAINS" ]]; then
    # shellcheck disable=SC2086
    security list-keychains -d user -s $ORIGINAL_KEYCHAINS >/dev/null 2>&1 || true
  fi
  if [[ -n "$TMP_KEYCHAIN" && -f "$TMP_KEYCHAIN" ]]; then
    security delete-keychain "$TMP_KEYCHAIN" >/dev/null 2>&1 || true
  fi
}
trap cleanup_tmp_keychain EXIT

if [[ -n "${P12_PATH:-}" && -f "$P12_PATH" ]]; then
  TMP_KEYCHAIN="$(mktemp -t biyan-codesign).keychain-db"
  TMP_PASS="$(openssl rand -hex 12)"
  security create-keychain -p "$TMP_PASS" "$TMP_KEYCHAIN"
  security set-keychain-settings -lut 21600 "$TMP_KEYCHAIN"
  security unlock-keychain -p "$TMP_PASS" "$TMP_KEYCHAIN"
  security import "$P12_PATH" -k "$TMP_KEYCHAIN" -P "$P12_PASSWORD" -T /usr/bin/codesign -T /usr/bin/security
  security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$TMP_PASS" "$TMP_KEYCHAIN" >/dev/null
  # shellcheck disable=SC2086
  security list-keychains -d user -s "$TMP_KEYCHAIN" $ORIGINAL_KEYCHAINS
  IDENTITY="$(security find-identity -v -p codesigning "$TMP_KEYCHAIN" | awk '/Apple Distribution/{print $2; exit}')"
  [[ -n "$IDENTITY" ]] || {
    echo "P12 中未找到可用的 Distribution 证书" >&2
    exit 1
  }
  echo "Using identity from P12: $IDENTITY"
fi

echo "Signing with identity: $IDENTITY"

sign_item() {
  local target="$1"
  local args=(--force --sign "$IDENTITY" --timestamp)
  [[ -n "$TMP_KEYCHAIN" ]] && args+=(--keychain "$TMP_KEYCHAIN")
  # App Store 校验需要带 timestamp 的签名；失败则直接报错，不再静默降级
  codesign "${args[@]}" "$target"
}

sign_framework_tree() {
  local fw="$1"
  # 由内向外：先签 privacy.bundle，再签 .framework
  while IFS= read -r -d '' bundle; do
    sign_item "$bundle"
  done < <(find "$fw" -type d -name "*.bundle" -print0 2>/dev/null)
  sign_item "$fw"
}

strip_c_comments_file() {
  python3 - "$1" <<'PY'
import sys, re, pathlib
path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8", errors="ignore")
out, i, n = [], 0, len(text)
while i < n:
    if text[i] in "\"'":
        q = text[i]; out.append(q); i += 1
        while i < n:
            c = text[i]; out.append(c); i += 1
            if c == "\\" and i < n:
                out.append(text[i]); i += 1; continue
            if c == q: break
        continue
    if text.startswith("//", i):
        while i < n and text[i] != "\n": i += 1
        continue
    if text.startswith("/*", i):
        j = text.find("*/", i + 2)
        i = n if j < 0 else j + 2
        continue
    out.append(text[i]); i += 1
path.write_text(re.sub(r"\n{3,}", "\n\n", "".join(out)), encoding="utf-8")
PY
}

# 在 Release 就地处理并签名（避免宿主误用未签名的 Release）
WORK_DIR="$RELEASE_DIR"

# 不要改 Flutter.framework 内部文件，会破坏官方密封签名
while IFS= read -r -d '' f; do
  case "$f" in
    */Flutter.xcframework/*|*/dSYMs/*) continue ;;
    *.framework/*) continue ;;
  esac
  strip_c_comments_file "$f"
done < <(find "$WORK_DIR" \( -name "*.h" -o -name "*.m" -o -name "*.hpp" -o -name "*.hh" -o -name "*.swift" \) -type f -print0)

while IFS= read -r -d '' f; do
  case "$f" in
    */Flutter.xcframework/*|*/dSYMs/*) continue ;;
  esac
  strip_c_comments_file "$f"
done < <(find "$WORK_DIR" -path '*.framework/*' \( -name "*.h" -o -name "*.m" -o -name "*.hpp" -o -name "*.hh" -o -name "*.swift" \) -type f -print0)

OUTPUT_DIR="$OUTPUT_DIR" python3 - <<'PY'
from pathlib import Path
import os, re
src = Path(os.environ["OUTPUT_DIR"])
for name in ("GeneratedPluginRegistrant.h", "GeneratedPluginRegistrant.m"):
    path = src / name
    if not path.exists():
        continue
    text = path.read_text(encoding="utf-8")
    out, i, n = [], 0, len(text)
    while i < n:
        if text.startswith("//", i):
            while i < n and text[i] != "\n": i += 1
            continue
        if text.startswith("/*", i):
            j = text.find("*/", i + 2)
            i = n if j < 0 else j + 2
            continue
        if text[i] in "\"'":
            q = text[i]; out.append(q); i += 1
            while i < n:
                c = text[i]; out.append(c); i += 1
                if c == "\\" and i < n:
                    out.append(text[i]); i += 1; continue
                if c == q: break
            continue
        out.append(text[i]); i += 1
    path.write_text(re.sub(r"\n{3,}", "\n\n", "".join(out)).strip() + "\n", encoding="utf-8")
PY

# 只给非 Flutter 的内层 framework / bundle 签 iOS 证书（ITMS-91065 关键）
while IFS= read -r -d '' fw; do
  case "$fw" in
    *dSYMs*|*/Flutter.xcframework/*) continue ;;
  esac
  echo "Sign framework: $fw"
  sign_framework_tree "$fw"
done < <(find "$WORK_DIR" -name "*.framework" -type d -print0)

while IFS= read -r -d '' xcfw; do
  case "$xcfw" in
    */Flutter.xcframework) continue ;;
  esac
  echo "Sign xcframework: $xcfw"
  sign_item "$xcfw"
done < <(find "$WORK_DIR" -name "*.xcframework" -type d -print0)

# ITMS-91065 硬校验：内层 framework 必须有 _CodeSignature、可 verify、带 Timestamp
fail=0
for xcfw in "$WORK_DIR"/*.xcframework; do
  name="$(basename "$xcfw" .xcframework)"
  has_dev=0
  has_sim=0
  ok=1
  while IFS= read -r -d '' fw; do
    case "$fw" in *dSYMs*) continue ;; esac
    rel="${fw#*$name.xcframework/}"
    slice="${rel%%/*}"
    case "$slice" in
      ios-arm64) has_dev=1 ;;
      *simulator*) has_sim=1 ;;
    esac

    info="$(codesign -dv --verbose=2 "$fw" 2>&1 || true)"
    auth="$(echo "$info" | awk -F= '/^Authority=/{print $2; exit}')"
    team="$(echo "$info" | awk -F= '/^TeamIdentifier=/{print $2; exit}')"
    ts="$(echo "$info" | awk -F= '/^Timestamp=/{print $2; exit}')"

    if [[ ! -f "$fw/_CodeSignature/CodeResources" ]]; then
      echo "MISSING _CodeSignature: $fw" >&2
      ok=0
    fi

    if [[ "$name" == "Flutter" ]]; then
      if [[ "$auth" != *"$FLUTTER_AUTHORITY_MATCH"* || "$team" != "$FLUTTER_TEAM_ID" ]]; then
        ok=0
      elif ! codesign --verify --deep --strict "$fw" 2>/dev/null; then
        ok=0
      fi
    else
      if [[ -z "$ts" ]]; then
        echo "MISSING Timestamp: $fw" >&2
        ok=0
      fi
      if [[ "$auth" != *"$AUTHORITY_MATCH"* || "$team" != "$TEAM_ID" ]]; then
        ok=0
      elif ! codesign --verify --deep --strict "$fw" 2>/dev/null; then
        ok=0
      fi
      # 二进制本身也必须带签名（Apple 报告路径是 Frameworks/xxx.framework/xxx）
      bin="$fw/$(basename "$fw" .framework)"
      if [[ -f "$bin" ]] && ! codesign --verify --strict "$bin" 2>/dev/null; then
        echo "BINARY UNSIGNED: $bin" >&2
        ok=0
      fi
    fi
    echo "  $name/$slice auth=${auth:-none} team=${team:-none} ts=${ts:-none}"
  done < <(find "$xcfw" -name "*.framework" -type d -print0)

  if [[ "$has_dev" -eq 1 && "$has_sim" -eq 1 && "$ok" -eq 1 ]]; then
    echo "OK $name"
  else
    echo "FAIL $name (device=$has_dev sim=$has_sim ok=$ok)"
    fail=1
  fi
done
[[ "$fail" -eq 0 ]] || exit 1

# 组装与 chumo_ios_framework 一致的交付目录：Release/ + registrant
mkdir -p "$EXPORT_DIR/Release"
for xcfw in "$WORK_DIR"/*.xcframework; do
  COPYFILE_DISABLE=1 ditto "$xcfw" "$EXPORT_DIR/Release/$(basename "$xcfw")"
done
for name in GeneratedPluginRegistrant.h GeneratedPluginRegistrant.m; do
  [[ -f "$OUTPUT_DIR/$name" ]] && cp "$OUTPUT_DIR/$name" "$EXPORT_DIR/$name"
done
printf '%s\n' "$IDENTITY" > "$EXPORT_DIR/.codesign_identity"

find "$EXPORT_DIR" \( -name '._*' -o -name '.DS_Store' \) -delete

ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"
(
  cd "$EXPORT_DIR"
  COPYFILE_DISABLE=1 zip -r -X "$ROOT_DIR/$ZIP_PATH" . \
    -x '*.DS_Store' -x '*._*' >/dev/null
)
if [[ -n "${DESKTOP_COPY:-}" && -d "$(dirname "$DESKTOP_COPY")" ]]; then
  cp "$ZIP_PATH" "$DESKTOP_COPY"
  echo "Zip: $DESKTOP_COPY"
fi
echo "Zip: $ZIP_PATH"
echo "Export dir: $EXPORT_DIR"
