import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biyan/widgets/app_image.dart';
import 'package:biyan/models/banner_item.dart';
import 'package:biyan/models/diary_entry.dart';
import 'package:biyan/models/memo_item.dart';
import 'package:biyan/models/outfit_item.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/models/watched_movie.dart';
import 'package:biyan/screens/home/banner_detail_screen.dart';
import 'package:biyan/screens/home/banner_more_screen.dart';
import 'package:biyan/screens/home/complaint_screen.dart';
import 'package:biyan/screens/home/home_tab.dart';
import 'package:biyan/screens/home/outfit_detail_screen.dart';
import 'package:biyan/screens/hobbies/hobbies_tab.dart';
import 'package:biyan/screens/profile/delete_account_screen.dart';
import 'package:biyan/screens/profile/edit_profile_screen.dart';
import 'package:biyan/screens/profile/help_feedback_screen.dart';
import 'package:biyan/screens/profile/memo_detail_screen.dart';
import 'package:biyan/screens/profile/profile_tab.dart';
import 'package:biyan/screens/profile/settings_screen.dart';
import 'package:biyan/screens/profile/settings_text_screen.dart';
import 'package:biyan/screens/time/add_diary_screen.dart';
import 'package:biyan/screens/time/companion_detail_screen.dart';
import 'package:biyan/screens/time/diary_detail_screen.dart';
import 'package:biyan/screens/time/movies_screen.dart';
import 'package:biyan/screens/time/time_tab.dart';
import 'package:biyan/services/storage_service.dart';
import 'package:biyan/services/voice_storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/bottom_nav_bar.dart';

enum SecondaryScreenType {
  bannerDetail,
  bannerMore,
  complaint,
  outfitDetail,
  diaryDetail,
  addDiary,
  memoDetail,
  companionDetail,
  moviesList,
  editProfile,
  settings,
  helpFeedback,
  settingsDoc,
  deleteAccount,
}

class SecondaryScreen {
  const SecondaryScreen({
    required this.type,
    this.banner,
    this.outfit,
    this.diary,
    this.memo,
    this.settingsDoc,
    this.complaintReturnToProfile = false,
  });

  final SecondaryScreenType type;
  final BannerItem? banner;
  final OutfitItem? outfit;
  final DiaryEntry? diary;
  final MemoItem? memo;
  final SettingsDocType? settingsDoc;
  final bool complaintReturnToProfile;
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.onSessionEnded,
  });

  final VoidCallback? onSessionEnded;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTab = 0;

  List<String> _selectedHobbies = [];
  List<String> _customTags = [];
  List<DiaryEntry> _diaryEntries = [];
  List<MemoItem> _memos = [];
  int _companionDays = 365;
  int _moviesWatched = 28;
  DateTime _companionStartDate = DateTime.now();
  List<WatchedMovie> _watchedMovies = [];
  Set<int> _blockedOutfitIds = {};
  Set<int> _blockedBannerIds = {};
  Set<String> _blockedAuthorIds = {};
  UserProfile _userProfile = UserProfile.defaultProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait<dynamic>([
      StorageService.loadSelectedHobbies(),
      StorageService.loadCustomTags(),
      StorageService.loadDiaryEntries(),
      StorageService.loadMemos(),
      StorageService.loadCompanionStartDate(),
      StorageService.loadWatchedMovies(),
      StorageService.loadBlockedOutfitIds(),
      StorageService.loadBlockedBannerIds(),
      StorageService.loadBlockedAuthorIds(),
      StorageService.loadUserProfile(),
    ]);

    if (!mounted) return;
    final startDate = results[4] as DateTime;
    final watchedMovies = results[5] as List<WatchedMovie>;
    setState(() {
      _selectedHobbies = results[0] as List<String>;
      _customTags = results[1] as List<String>;
      _diaryEntries = results[2] as List<DiaryEntry>;
      _memos = results[3] as List<MemoItem>;
      _companionStartDate = startDate;
      _companionDays = StorageService.companionDaysFromStart(startDate);
      _watchedMovies = watchedMovies;
      _moviesWatched = watchedMovies.length;
      _blockedOutfitIds = results[6] as Set<int>;
      _blockedBannerIds = results[7] as Set<int>;
      _blockedAuthorIds = results[8] as Set<String>;
      _userProfile = results[9] as UserProfile;
    });
  }

  void _pushScreen(SecondaryScreen screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _buildSecondaryScreen(screen),
      ),
    );
  }

  void _popScreen() {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  void _popAllSecondaryScreens() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _goHome({String message = '投诉已提交'}) {
    _popAllSecondaryScreens();
    setState(() => _currentTab = 0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _returnToProfile({required String message}) {
    _popAllSecondaryScreens();
    setState(() => _currentTab = 3);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _shieldOutfit(int outfitId) async {
    final updated = {..._blockedOutfitIds, outfitId};
    setState(() => _blockedOutfitIds = updated);
    await StorageService.saveBlockedOutfitIds(updated);
    if (!mounted) return;
    _goHome(message: '已屏蔽该内容');
  }

  Future<void> _shieldBanner(int bannerId) async {
    final updated = {..._blockedBannerIds, bannerId};
    setState(() => _blockedBannerIds = updated);
    await StorageService.saveBlockedBannerIds(updated);
    if (!mounted) return;
    _goHome(message: '已屏蔽该内容');
  }

  Future<void> _blockAuthor(String authorId, String authorName) async {
    final updated = {..._blockedAuthorIds, authorId};
    setState(() => _blockedAuthorIds = updated);
    await StorageService.saveBlockedAuthorIds(updated);
    if (!mounted) return;
    _goHome(message: '已拉黑$authorName');
  }

  Future<void> _updateCompanionStartDate(DateTime date) async {
    await StorageService.saveCompanionStartDate(date);
    if (!mounted) return;
    setState(() {
      _companionStartDate = date;
      _companionDays = StorageService.companionDaysFromStart(date);
    });
  }

  Future<void> _updateWatchedMovies(List<WatchedMovie> movies) async {
    await StorageService.saveWatchedMovies(movies);
    if (!mounted) return;
    setState(() {
      _watchedMovies = movies;
      _moviesWatched = movies.length;
    });
  }

  Future<void> _updateUserProfile(UserProfile profile) async {
    await StorageService.saveUserProfile(profile);
    if (!mounted) return;
    setState(() => _userProfile = profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('资料已更新')),
    );
  }

  Future<void> _logout() async {
    await StorageService.setLoggedIn(false);
    await StorageService.resetUserProfile();
    if (!mounted) return;
    _endSession();
  }

  Future<void> _deleteAccount() async {
    await StorageService.clearAllData();
    if (!mounted) return;
    _endSession();
  }

  void _endSession() {
    _popAllSecondaryScreens();
    widget.onSessionEnded?.call();
  }

  Future<void> _updateHobbies(List<String> hobbies) async {
    setState(() => _selectedHobbies = hobbies);
    await StorageService.saveSelectedHobbies(hobbies);
  }

  Future<void> _updateCustomTags(List<String> tags) async {
    setState(() => _customTags = tags);
    await StorageService.saveCustomTags(tags);
  }

  Future<void> _addDiary(DiaryEntry entry) async {
    final updated = [entry, ..._diaryEntries];
    setState(() => _diaryEntries = updated);
    await StorageService.saveDiaryEntries(updated);
  }

  Future<void> _deleteDiary(DiaryEntry entry) async {
    for (final image in entry.images) {
      if (isLocalImagePath(image)) {
        final file = File(localImagePath(image));
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await VoiceStorageService.deleteVoice(entry.voicePath);
    final updated = _diaryEntries.where((e) => e.id != entry.id).toList();
    setState(() => _diaryEntries = updated);
    await StorageService.saveDiaryEntries(updated);
    _popScreen();
  }

  Future<void> _addMemo(String title, String content) async {
    final now = DateFormat('MM-dd').format(DateTime.now());
    final memo = MemoItem(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title.isEmpty ? '无标题' : title,
      content: content,
      date: now,
    );
    final updated = [memo, ..._memos];
    setState(() => _memos = updated);
    await StorageService.saveMemos(updated);
  }

  Future<void> _deleteMemo(int id) async {
    final updated = _memos.where((m) => m.id != id).toList();
    setState(() => _memos = updated);
    await StorageService.saveMemos(updated);
  }

  Future<void> _updateMemo(MemoItem memo) async {
    final updated = _memos.map((m) => m.id == memo.id ? memo : m).toList();
    setState(() => _memos = updated);
    await StorageService.saveMemos(updated);
  }

  Widget _buildTabStack() {
    return IndexedStack(
      index: _currentTab,
      children: [
        HomeTab(
          profile: _userProfile,
          blockedOutfitIds: _blockedOutfitIds,
          blockedBannerIds: _blockedBannerIds,
          blockedAuthorIds: _blockedAuthorIds,
          onBannerTap: (banner) => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.bannerDetail,
              banner: banner,
            ),
          ),
          onOutfitTap: (outfit) => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.outfitDetail,
              outfit: outfit,
            ),
          ),
        ),
        HobbiesTab(
          profile: _userProfile,
          selectedHobbies: _selectedHobbies,
          customTags: _customTags,
          onHobbiesChanged: _updateHobbies,
          onCustomTagsChanged: _updateCustomTags,
        ),
        TimeTab(
          diaryEntries: _diaryEntries,
          companionDays: _companionDays,
          moviesWatched: _moviesWatched,
          onDiaryTap: (entry) => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.diaryDetail,
              diary: entry,
            ),
          ),
          onAddDiary: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.addDiary),
          ),
          onCompanionTap: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.companionDetail),
          ),
          onMoviesTap: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.moviesList),
          ),
        ),
        ProfileTab(
          profile: _userProfile,
          memos: _memos,
          onEditProfile: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.editProfile),
          ),
          onSettings: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.settings),
          ),
          onAddMemo: _addMemo,
          onDeleteMemo: _deleteMemo,
          onMemoTap: (memo) => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.memoDetail,
              memo: memo,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryScreen(SecondaryScreen screen) {
    switch (screen.type) {
      case SecondaryScreenType.bannerDetail:
        return BannerDetailScreen(
          banner: screen.banner!,
          onBack: _popScreen,
          onShield: () => _shieldBanner(screen.banner!.id),
          onBlock: () => _blockAuthor(
            screen.banner!.authorId,
            screen.banner!.authorName,
          ),
          onComplaint: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.complaint),
          ),
        );
      case SecondaryScreenType.complaint:
        return ComplaintScreen(
          onBack: _popScreen,
          onSubmit: screen.complaintReturnToProfile
              ? () => _returnToProfile(message: '投诉已提交')
              : () => _goHome(),
        );
      case SecondaryScreenType.bannerMore:
        return BannerMoreScreen(
          banner: screen.banner!,
          onBack: _popScreen,
        );
      case SecondaryScreenType.outfitDetail:
        return OutfitDetailScreen(
          outfit: screen.outfit!,
          onBack: _popScreen,
          onShield: () => _shieldOutfit(screen.outfit!.id),
          onBlock: () => _blockAuthor(
            screen.outfit!.authorId,
            screen.outfit!.authorName,
          ),
          onComplaint: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.complaint),
          ),
        );
      case SecondaryScreenType.diaryDetail:
        return DiaryDetailScreen(
          diary: screen.diary!,
          onBack: _popScreen,
          onDelete: () => _deleteDiary(screen.diary!),
        );
      case SecondaryScreenType.addDiary:
        return AddDiaryScreen(
          onBack: _popScreen,
          onPublish: _addDiary,
        );
      case SecondaryScreenType.memoDetail:
        return MemoDetailScreen(
          memo: screen.memo!,
          onBack: _popScreen,
          onSave: _updateMemo,
        );
      case SecondaryScreenType.companionDetail:
        return CompanionDetailScreen(
          companionDays: _companionDays,
          startDate: _companionStartDate,
          nickname: _userProfile.nickname,
          onBack: _popScreen,
          onStartDateChanged: _updateCompanionStartDate,
        );
      case SecondaryScreenType.moviesList:
        return MoviesScreen(
          movies: _watchedMovies,
          onBack: _popScreen,
          onMoviesChanged: _updateWatchedMovies,
        );
      case SecondaryScreenType.editProfile:
        return EditProfileScreen(
          profile: _userProfile,
          onBack: _popScreen,
          onSave: _updateUserProfile,
        );
      case SecondaryScreenType.settings:
        return SettingsScreen(
          onBack: _popScreen,
          onHelpFeedback: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.helpFeedback),
          ),
          onComplaint: () => _pushScreen(
            const SecondaryScreen(
              type: SecondaryScreenType.complaint,
              complaintReturnToProfile: true,
            ),
          ),
          onUserNotice: () => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.settingsDoc,
              settingsDoc: SettingsDocType.userNotice,
            ),
          ),
          onPrivacy: () => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.settingsDoc,
              settingsDoc: SettingsDocType.privacy,
            ),
          ),
          onAbout: () => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.settingsDoc,
              settingsDoc: SettingsDocType.about,
            ),
          ),
          onDeleteAccount: () => _pushScreen(
            const SecondaryScreen(type: SecondaryScreenType.deleteAccount),
          ),
          onLogout: _logout,
        );
      case SecondaryScreenType.helpFeedback:
        return HelpFeedbackScreen(
          onBack: _popScreen,
          onSubmit: () => _returnToProfile(message: '反馈已提交，感谢你的建议'),
        );
      case SecondaryScreenType.settingsDoc:
        return SettingsTextScreen(
          type: screen.settingsDoc!,
          onBack: _popScreen,
        );
      case SecondaryScreenType.deleteAccount:
        return DeleteAccountScreen(
          onBack: _popScreen,
          onOpenNotice: () => _pushScreen(
            SecondaryScreen(
              type: SecondaryScreenType.settingsDoc,
              settingsDoc: SettingsDocType.deleteAccountNotice,
            ),
          ),
          onConfirm: _deleteAccount,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabBackground = _currentTab == 2
        ? AppColors.backgroundGray
        : _currentTab == 3
            ? Colors.grey.shade50
            : AppColors.background;
    return Scaffold(
      backgroundColor: tabBackground,
      body: SafeArea(
        bottom: false,
        child: _buildTabStack(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentTab,
        onTap: (index) => setState(() => _currentTab = index),
      ),
    );
  }
}
