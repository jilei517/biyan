import 'dart:async';
import 'dart:convert';

import 'package:biyan/data/app_data.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/models/memo_item.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/models/watched_movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static const String _keyHobbies = 'selected_hobbies';
  static const String _keyCustomTags = 'custom_tags';
  static const String _keyDiaries = 'diary_entries';
  static const String _keyDiariesVersion = 'diary_entries_version';
  static const int _diariesVersion = 4;
  static const Set<int> _sampleDiaryIds = {101, 102};
  static const String _keyMemos = 'memos';
  static const String _keyCompanionDays = 'companion_days';
  static const String _keyCompanionStartDate = 'companion_start_date';
  static const String _keyMoviesWatched = 'movies_watched';
  static const String _keyWatchedMovies = 'watched_movies';
  static const String _keyBlockedOutfitIds = 'blocked_outfit_ids';
  static const String _keyBlockedBannerIds = 'blocked_banner_ids';
  static const String _keyBlockedAuthorIds = 'blocked_author_ids';
  static const String _keyUserProfile = 'user_profile';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyAccounts = 'registered_accounts';
  static const Map<String, String> _builtInAccounts = {
    '19246891921': 'zzz121',
  };

  static SharedPreferences? _cachedPrefs;

  static Future<SharedPreferences> get _prefs async {
    _cachedPrefs ??= await SharedPreferences.getInstance();
    return _cachedPrefs!;
  }

  static Future<void> warmup() async {
    await _prefs;
  }

  static Future<List<String>> loadSelectedHobbies() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_keyHobbies);
    if (list == null || list.isEmpty) {
      return List<String>.from(AppData.defaultSelectedHobbies);
    }
    return list;
  }

  static Future<void> saveSelectedHobbies(List<String> hobbies) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyHobbies, hobbies);
  }

  static Future<List<String>> loadCustomTags() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_keyCustomTags);
    if (list == null || list.isEmpty) {
      return List<String>.from(AppData.defaultCustomTags);
    }
    return list;
  }

  static Future<void> saveCustomTags(List<String> tags) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyCustomTags, tags);
  }

  static Future<List<DiaryEntry>> loadDiaryEntries() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyDiaries);
    final storedVersion = prefs.getInt(_keyDiariesVersion) ?? 1;

    if (raw == null || raw.isEmpty) {
      final defaults = AppData.defaultDiaryEntries();
      unawaited(saveDiaryEntries(defaults).then((_) {
        return prefs.setInt(_keyDiariesVersion, _diariesVersion);
      }));
      return defaults;
    }

    final existing = (jsonDecode(raw) as List<dynamic>)
        .map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    if (storedVersion < _diariesVersion) {
      final defaults = AppData.defaultDiaryEntries();
      final defaultById = {for (final e in defaults) e.id: e};
      final merged = existing.map((e) {
        if (_sampleDiaryIds.contains(e.id) && defaultById.containsKey(e.id)) {
          return defaultById[e.id]!;
        }
        return e;
      }).toList();
      final existingIds = merged.map((e) => e.id).toSet();
      merged.addAll(defaults.where((e) => !existingIds.contains(e.id)));
      merged.sort((a, b) {
        final aDate = a.fullDate ?? '${a.year}-${a.month}-${a.day}';
        final bDate = b.fullDate ?? '${b.year}-${b.month}-${b.day}';
        return bDate.compareTo(aDate);
      });
      await saveDiaryEntries(merged);
      await prefs.setInt(_keyDiariesVersion, _diariesVersion);
      return merged;
    }

    return existing;
  }

  static Future<void> saveDiaryEntries(List<DiaryEntry> entries) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_keyDiaries, encoded);
  }

  static Future<List<MemoItem>> loadMemos() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyMemos);
    if (raw == null || raw.isEmpty) {
      return AppData.defaultMemos();
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => MemoItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveMemos(List<MemoItem> memos) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(memos.map((e) => e.toJson()).toList());
    await prefs.setString(_keyMemos, encoded);
  }

  static Future<int> loadCompanionDays() async {
    final startDate = await loadCompanionStartDate();
    return companionDaysFromStart(startDate);
  }

  static Future<DateTime> loadCompanionStartDate() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyCompanionStartDate);
    if (raw != null && raw.isNotEmpty) {
      return DateTime.parse(raw);
    }

    final legacyDays = prefs.getInt(_keyCompanionDays) ?? 365;
    final start = DateTime.now().subtract(Duration(days: legacyDays - 1));
    await saveCompanionStartDate(start);
    return start;
  }

  static Future<void> saveCompanionStartDate(DateTime date) async {
    final prefs = await _prefs;
    final normalized = DateTime(date.year, date.month, date.day);
    await prefs.setString(
      _keyCompanionStartDate,
      normalized.toIso8601String().split('T').first,
    );
  }

  static int companionDaysFromStart(DateTime startDate) {
    final today = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    return todayDate.difference(start).inDays + 1;
  }

  static Future<int> loadMoviesWatched() async {
    final movies = await loadWatchedMovies();
    return movies.length;
  }

  static Future<List<WatchedMovie>> loadWatchedMovies() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyWatchedMovies);
    if (raw == null || raw.isEmpty) {
      final defaults = AppData.defaultWatchedMovies();
      unawaited(saveWatchedMovies(defaults));
      return defaults;
    }

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => WatchedMovie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> saveWatchedMovies(List<WatchedMovie> movies) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(movies.map((e) => e.toJson()).toList());
    await prefs.setString(_keyWatchedMovies, encoded);
    await prefs.setInt(_keyMoviesWatched, movies.length);
  }

  static Future<Set<int>> loadBlockedOutfitIds() async {
    return _loadIntSet(_keyBlockedOutfitIds);
  }

  static Future<void> saveBlockedOutfitIds(Set<int> ids) async {
    await _saveIntSet(_keyBlockedOutfitIds, ids);
  }

  static Future<Set<int>> loadBlockedBannerIds() async {
    return _loadIntSet(_keyBlockedBannerIds);
  }

  static Future<void> saveBlockedBannerIds(Set<int> ids) async {
    await _saveIntSet(_keyBlockedBannerIds, ids);
  }

  static Future<Set<String>> loadBlockedAuthorIds() async {
    final prefs = await _prefs;
    final list = prefs.getStringList(_keyBlockedAuthorIds);
    if (list == null || list.isEmpty) return {};
    return list.toSet();
  }

  static Future<void> saveBlockedAuthorIds(Set<String> ids) async {
    final prefs = await _prefs;
    await prefs.setStringList(_keyBlockedAuthorIds, ids.toList());
  }

  static Future<Set<int>> _loadIntSet(String key) async {
    final prefs = await _prefs;
    final list = prefs.getStringList(key);
    if (list == null || list.isEmpty) return {};
    return list.map(int.parse).toSet();
  }

  static Future<void> _saveIntSet(String key, Set<int> ids) async {
    final prefs = await _prefs;
    await prefs.setStringList(key, ids.map((id) => id.toString()).toList());
  }

  static Future<UserProfile> loadUserProfile() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyUserProfile);
    if (raw == null || raw.isEmpty) {
      final defaults = UserProfile.defaultProfile;
      unawaited(saveUserProfile(defaults));
      return defaults;
    }
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUserProfile, jsonEncode(profile.toJson()));
  }

  static Future<void> resetUserProfile() async {
    await saveUserProfile(UserProfile.defaultProfile);
  }

  static Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<Map<String, String>> loadAccounts() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyAccounts);
    final stored = <String, String>{};
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      stored.addAll(
        decoded.map((key, value) => MapEntry(key, value.toString())),
      );
    }
    return {...stored, ..._builtInAccounts};
  }

  static Future<void> _saveAccounts(Map<String, String> accounts) async {
    final prefs = await _prefs;
    await prefs.setString(_keyAccounts, jsonEncode(accounts));
  }

  static Future<bool> accountExists(String account) async {
    final accounts = await loadAccounts();
    return accounts.containsKey(account.trim());
  }

  static const int phoneLength = 11;
  static const int minPasswordLength = 6;
  static final RegExp _phonePattern = RegExp(r'^\d{11}$');

  static String? validatePhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return '请输入手机号码';
    if (!_phonePattern.hasMatch(trimmed)) return '请输入11位手机号码';
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return '请输入密码';
    if (password.length < minPasswordLength) return '密码至少6位';
    return null;
  }

  static Future<String?> registerAccount(String account, String password) async {
    final phoneError = validatePhone(account);
    if (phoneError != null) return phoneError;
    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;
    final trimmed = account.trim();
    final accounts = await loadAccounts();
    if (accounts.containsKey(trimmed)) return '该手机号已注册';
    accounts[trimmed] = password;
    await _saveAccounts(accounts);
    return null;
  }

  static Future<String?> validateLogin(String account, String password) async {
    final phoneError = validatePhone(account);
    if (phoneError != null) return phoneError;
    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;
    final trimmed = account.trim();
    final accounts = await loadAccounts();
    if (!accounts.containsKey(trimmed)) return '该手机号未注册';
    if (accounts[trimmed] != password) return '手机号或密码错误';
    return null;
  }
}
