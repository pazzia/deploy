import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress.dart';

class ProgressStore {
  static const _completedKey = 'completed_levels';
  static const _xpKey = 'total_xp';
  static const _livesKey = 'lives';
  static const _streakKey = 'streak';
  static const _lastActiveKey = 'last_active_day';
  static const _onboardingKey = 'onboarding_done';

  Future<AppProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppProgress(
      completedLevelIds: prefs.getStringList(_completedKey) ?? const <String>[],
      totalXp: prefs.getInt(_xpKey) ?? 0,
      lives: prefs.getInt(_livesKey) ?? 5,
      streak: prefs.getInt(_streakKey) ?? 0,
      lastActiveDay: prefs.getString(_lastActiveKey),
      onboardingDone: prefs.getBool(_onboardingKey) ?? false,
    );
  }

  Future<void> save(AppProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedKey, progress.completedLevelIds);
    await prefs.setInt(_xpKey, progress.totalXp);
    await prefs.setInt(_livesKey, progress.lives);
    await prefs.setInt(_streakKey, progress.streak);
    if (progress.lastActiveDay != null) await prefs.setString(_lastActiveKey, progress.lastActiveDay!);
    await prefs.setBool(_onboardingKey, progress.onboardingDone);
  }
}
