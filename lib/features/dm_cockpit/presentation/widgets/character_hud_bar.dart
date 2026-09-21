import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../campaign_rules/domain/models/character_model.dart';
import '../../../campaign_rules/presentation/state_providers.dart';

class CharacterHudBar extends ConsumerWidget {
  const CharacterHudBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(partyCharactersProvider);
    final notifier = ref.read(partyCharactersProvider.notifier);

    if (characters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.graniteBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_alt_outlined, size: 16, color: AppTheme.bronzePrimary),
                  const SizedBox(width: 8),
                  Text(
                    'PARTY HEALTH & TRACKING (4 HEROES)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.bronzeLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 1.1,
                        ),
                  ),
                ],
              ),
              const Text(
                'Live State',
                style: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isWide ? 1.6 : 2.1,
                children: characters.values.map((char) {
                  return _buildCharacterMiniCard(context, char, notifier);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterMiniCard(
    BuildContext context,
    ActiveCharacter char,
    CharactersNotifier notifier,
  ) {
    final hpPercent = (char.currentHp / char.maxHp).clamp(0.0, 1.0);
    final isLowHp = hpPercent < 0.35;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.graniteDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: char.isIncapacitated
              ? AppTheme.terracotta
              : (isLowHp ? AppTheme.terracotta.withValues(alpha: 0.5) : AppTheme.graniteBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  char.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.parchment,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${char.currentHp}/${char.maxHp} HP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isLowHp ? AppTheme.terracotta : AppTheme.bronzeLight,
                ),
              ),
            ],
          ),
          if (char.playerName.isNotEmpty)
            Text(
              char.playerName,
              style: const TextStyle(fontSize: 10, color: AppTheme.parchmentMuted),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 4),
          // Health Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: hpPercent,
              minHeight: 5,
              backgroundColor: AppTheme.graniteCard,
              valueColor: AlwaysStoppedAnimation<Color>(
                char.isIncapacitated
                    ? AppTheme.terracotta
                    : (isLowHp ? AppTheme.terracotta : AppTheme.bronzePrimary),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Quick +/- HP Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STAM: ${char.stamina}',
                style: const TextStyle(fontSize: 9, color: AppTheme.parchmentMuted),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => notifier.adjustHp(char.id, -1),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.graniteCard,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.remove, size: 14, color: AppTheme.terracotta),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => notifier.adjustHp(char.id, 1),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.graniteCard,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.add, size: 14, color: AppTheme.verdigris),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
