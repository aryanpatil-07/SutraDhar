import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../campaign_rules/domain/rules_engine.dart';
import '../../../campaign_rules/presentation/state_providers.dart';

class ActionQueueCard extends ConsumerWidget {
  final ProposedActionDelta delta;

  const ActionQueueCard({
    super.key,
    required this.delta,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final characters = ref.watch(partyCharactersProvider);

    final actingChar = characters[delta.actingCharacterId];
    final actingName = actingChar?.name ?? delta.actingCharacterId.toUpperCase();

    Color badgeColor;
    String typeLabel;
    switch (delta.actionType) {
      case ActionType.combatAction:
        badgeColor = AppTheme.terracotta;
        typeLabel = 'COMBAT ACTION';
        break;
      case ActionType.travel:
        badgeColor = AppTheme.verdigris;
        typeLabel = 'TRAVEL / MOVEMENT';
        break;
      case ActionType.investigation:
        badgeColor = AppTheme.bronzePrimary;
        typeLabel = 'INVESTIGATION';
        break;
      case ActionType.dialogue:
        badgeColor = Colors.indigoAccent;
        typeLabel = 'DIALOGUE';
        break;
      default:
        badgeColor = AppTheme.bronzePrimary;
        typeLabel = 'SKILL CHECK';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: badgeColor.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, size: 16, color: badgeColor),
                    const SizedBox(width: 6),
                    Text(
                      '$typeLabel • $actingName',
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidian,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AI PROPOSED',
                    style: TextStyle(fontSize: 10, color: AppTheme.parchmentMuted, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check Formula Badge (if check occurred)
                if (delta.checkEvaluation != null) ...[
                  _buildEvaluationBadge(delta.checkEvaluation!),
                  const SizedBox(height: 12),
                ],

                // Narration Prose (What GM reads aloud)
                Text(
                  'Narration (Read Aloud):',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bronzeLight,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.graniteDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.graniteBorder),
                  ),
                  child: Text(
                    '"${delta.narration}"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.parchment,
                      height: 1.4,
                    ),
                  ),
                ),

                // Secret GM Whisper / Note
                if (delta.gmSecretNote.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.bronzePrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.bronzePrimary.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lock_clock, size: 15, color: AppTheme.bronzePrimary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Secret DM Note: ${delta.gmSecretNote}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.bronzeLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Proposed State Deltas
                const SizedBox(height: 14),
                _buildStateDeltasRow(delta),

                const SizedBox(height: 18),

                // Accept / Reject Action Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.terracotta,
                          side: const BorderSide(color: AppTheme.terracotta),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          ref.read(pendingActionQueueProvider.notifier).remove(delta);
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('REJECT'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.bronzePrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          // Deterministically apply state changes
                          final result = RulesEngine.applyActionDelta(
                            currentGameState: gameState,
                            currentCharacters: characters,
                            delta: delta,
                          );
                          ref.read(gameStateProvider.notifier).updateState(result.updatedGameState);
                          ref.read(partyCharactersProvider.notifier).setCharacters(result.updatedCharacters);
                          ref.read(pendingActionQueueProvider.notifier).remove(delta);
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('ACCEPT DELTA'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationBadge(CheckEvaluation eval) {
    final isSuccess = eval.isSuccess;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSuccess
            ? AppTheme.verdigris.withValues(alpha: 0.15)
            : AppTheme.terracotta.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuccess ? AppTheme.verdigris : AppTheme.terracotta,
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            eval.formulaSummary,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.parchment,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isSuccess ? AppTheme.verdigris : AppTheme.terracotta,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              eval.isCriticalSuccess
                  ? 'CRIT SUCCESS (12)'
                  : (eval.isCriticalFailure
                      ? 'CRIT FAIL (2)'
                      : (isSuccess ? 'SUCCESS' : 'FAILED')),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateDeltasRow(ProposedActionDelta delta) {
    final pills = <Widget>[];

    if (delta.threatDelta != 0) {
      pills.add(_buildDeltaPill(
        'Threat ${delta.threatDelta > 0 ? "+${delta.threatDelta}" : delta.threatDelta}',
        delta.threatDelta > 0 ? AppTheme.terracotta : AppTheme.verdigris,
      ));
    }
    if (delta.suppliesDelta != 0) {
      pills.add(_buildDeltaPill(
        'Supplies ${delta.suppliesDelta}',
        AppTheme.terracotta,
      ));
    }
    if (delta.goldDelta != 0) {
      pills.add(_buildDeltaPill(
        'Gold ${delta.goldDelta > 0 ? "+${delta.goldDelta}" : delta.goldDelta}',
        AppTheme.bronzeLight,
      ));
    }
    delta.characterHpDeltas.forEach((cId, hp) {
      pills.add(_buildDeltaPill(
        '$cId HP ${hp > 0 ? "+$hp" : hp}',
        hp < 0 ? AppTheme.terracotta : AppTheme.verdigris,
      ));
    });
    for (final clue in delta.newClues) {
      pills.add(_buildDeltaPill('Clue: $clue', AppTheme.bronzePrimary));
    }

    if (pills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'State Changes to Apply:',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.parchmentMuted),
        ),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: pills),
      ],
    );
  }

  Widget _buildDeltaPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
