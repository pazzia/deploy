import 'package:flutter/foundation.dart';

import '../core/level_engine.dart';
import '../models/level.dart';
import '../models/progress.dart';
import '../services/progress_store.dart';

class AppController extends ChangeNotifier {
  AppController({ProgressStore? store, LevelEngine? engine})
      : _store = store ?? ProgressStore(),
        _engine = engine ?? const LevelEngine();

  final ProgressStore _store;
  final LevelEngine _engine;

  AppProgress progress = const AppProgress();
  bool initialized = false;

  Future<void> init() async {
    progress = await _store.load();
    initialized = true;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    progress = progress.copyWith(onboardingDone: true);
    await _store.save(progress);
    notifyListeners();
  }

  bool isUnlocked(List<Level> levels, int index) {
    if (index == 0) return true;
    return progress.completedLevelIds.contains(levels[index - 1].id);
  }

  Future<LevelResult> submit({required Level level, required String answer, required int mistakes}) async {
    final result = _engine.evaluate(level, answer, mistakes);
    if (result.isCorrect) {
      final alreadyCompleted = progress.completedLevelIds.contains(level.id);
      final completed = <String>[...progress.completedLevelIds];
      if (!alreadyCompleted) completed.add(level.id);
      progress = progress.copyWith(
        completedLevelIds: completed,
        totalXp: progress.totalXp + (alreadyCompleted ? 0 : result.xpAwarded),
        streak: _calculateStreak(progress.lastActiveDay, progress.streak),
        lastActiveDay: _today(),
      );
    } else {
      progress = progress.copyWith(lives: progress.lives > 0 ? progress.lives - 1 : 0);
    }
    await _store.save(progress);
    notifyListeners();
    return result;
  }

  int _calculateStreak(String? lastDay, int current) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    if (lastDay == null) return 1;
    final parsed = DateTime.tryParse(lastDay);
    if (parsed == null) return 1;
    final last = DateTime(parsed.year, parsed.month, parsed.day);
    final diff = normalizedToday.difference(last).inDays;
    if (diff == 0) return current == 0 ? 1 : current;
    if (diff == 1) return current + 1;
    return 1;
  }

  String _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).toIso8601String();
  }
}
