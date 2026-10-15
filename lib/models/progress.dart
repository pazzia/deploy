class AppProgress {
  const AppProgress({this.completedLevelIds = const <String>[], this.totalXp = 0, this.lives = 5, this.streak = 0, this.lastActiveDay, this.onboardingDone = false});
  final List<String> completedLevelIds;
  final int totalXp;
  final int lives;
  final int streak;
  final String? lastActiveDay;
  final bool onboardingDone;

  AppProgress copyWith({List<String>? completedLevelIds, int? totalXp, int? lives, int? streak, String? lastActiveDay, bool? onboardingDone}) {
    return AppProgress(
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      totalXp: totalXp ?? this.totalXp,
      lives: lives ?? this.lives,
      streak: streak ?? this.streak,
      lastActiveDay: lastActiveDay ?? this.lastActiveDay,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}
