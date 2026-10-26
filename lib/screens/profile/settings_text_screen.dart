import 'package:flutter/material.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

enum SettingsDocType { userNotice, privacy, about, deleteAccountNotice }

class SettingsTextScreen extends StatelessWidget {
  const SettingsTextScreen({
    super.key,
    required this.type,
    required this.onBack,
  });

  final SettingsDocType type;
  final VoidCallback onBack;

  String get _title {
    switch (type) {
      case SettingsDocType.userNotice:
        return '用户须知';
      case SettingsDocType.privacy:
        return '隐私协议';
      case SettingsDocType.about:
        return '关于我们';
      case SettingsDocType.deleteAccountNotice:
        return '账号注销须知';
    }
  }

  String get _content {
    switch (type) {
      case SettingsDocType.userNotice:
        return '''使用前请先看完。不同意就别继续。

1. 能做什么
看穿搭、记爱好、写日记（图和语音都行）、看在一起多少天、记看过的电影、改资料、写备忘。东西默认只存在这台手机上。

2. 账号
登录只是本机状态，不是实名。手机自己看好。退出会回登录页；注销会把本机数据全清掉，清完没有备份。

3. 别踩线
别拿这软件干违法的事，别发黄暴、骂人、侵权的内容，也别去破解程序。别人的照片和文字别随便拿来用。

4. 内容归谁
你写的日记、备忘归你。界面和推荐内容归彼颜。首页图是公开素材，看看就行，别商用。

5. 网络
穿搭图要联网。信号差可能刷不出来。

6. 以后可能改
功能有增减会在软件里说。不想用了就退出或注销。

7. 出问题
按现在能用的功能提供。系统升级、手机坏了或者自己点错，数据可能没了。能帮就帮，不保证一定能找回。

说明改了会写在软件里。接着用就当同意。有事走「设置 → 帮助与反馈」。''';
      case SettingsDocType.privacy:
        return '''彼颜隐私说明

2026 年 6 月。

日记和备忘我们不往自己的服务器传。不同意下面这些就别用。

会碰到的信息
你自己填的：登录手机号和密码、昵称、头像、签名、日记（含图和语音）、备忘、爱好、在一起的日期、看过的电影、反馈投诉、你屏蔽过的人。
本机自己记的：登没登录、一点界面缓存。
不要身份证、真名、定位、通讯录。你没点相册，我们也不会去翻。

拿来干什么
就为了把功能跑起来，不会拿去卖。

存在哪
当前手机的应用目录。退出会把资料打回默认，注销会全清。手机也设个锁屏，别随便借人。

权限
只有你主动选照片、录音才会弹。
相册：改头像、写日记、投诉配图。
麦克风：日记录音。
不想给就去系统设置关，对应功能会不可用。

联网
首页图要联网拉，图床可能会记 IP，以对方规则为准。相册、存储、录音用的是系统能力。

你可以改资料、删日记备忘、退出、注销、在系统里关权限。

未满 18 岁请跟家长一起看完再决定用不用。

改了会写在软件里。有问题走「设置 → 帮助与反馈」。''';
      case SettingsDocType.about:
        return '''彼颜 1.0.0

记穿搭、爱好和日常。日记备忘都在手机本地。

- 看穿搭和专题
- 给 TA 打标签
- 写图文 / 语音日记
- 看在一起多少天、一起看过什么电影
- 备忘录

开发：彼颜''';
      case SettingsDocType.deleteAccountNotice:
        return '''注销说明

2026 年 8 月 30 日起按这个来。点确定马上生效，没有撤回。

会清掉这台手机上和彼颜有关的东西：账号和登录状态、资料、日记、备忘、爱好、陪伴日期、观影记录、屏蔽拉黑、反馈投诉。

删完回登录页。以后要用得重新注册。你自己拷到相册或网盘的不受影响。

如果只是暂时不用，选退出就行，日记还在。

勾选同意并确定注销，就表示你知道后果，自愿清掉本机数据。

不清楚去「设置 → 帮助与反馈」。''';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(title: _title, onBack: onBack),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
