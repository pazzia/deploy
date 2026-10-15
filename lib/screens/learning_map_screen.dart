import 'package:flutter/material.dart';

import '../models/level.dart';
import '../models/progress.dart';

class LearningMapScreen extends StatelessWidget {
  const LearningMapScreen({super.key, required this.levels, required this.progress, required this.isUnlocked, required this.onLevel});
  final List<Level> levels;
  final AppProgress progress;
  final bool Function(int index) isUnlocked;
  final void Function(Level level) onLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Python Path')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          final showHeader = index == 0 || levels[index - 1].module != level.module;
          final done = progress.completedLevelIds.contains(level.id);
          final unlocked = isUnlocked(index);
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (showHeader) Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 10),
              child: Text(level.module, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ),
            Card(
              child: ListTile(
                enabled: unlocked,
                onTap: unlocked ? () => onLevel(level) : null,
                leading: CircleAvatar(child: Icon(done ? Icons.check : (unlocked ? Icons.code : Icons.lock_outline))),
                title: Text(level.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${level.xp} XP • ${_typeName(level.type)}'),
                trailing: done ? const Text('★★★') : const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 10),
          ]);
        },
      ),
    );
  }

  String _typeName(LevelType type) => switch (type) {
    LevelType.multipleChoice => 'Выбор ответа',
    LevelType.fillMissing => 'Пропуск в коде',
    LevelType.codeOrdering => 'Порядок строк',
  };
}
