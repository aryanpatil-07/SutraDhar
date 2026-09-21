import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/campaign_constants.dart';
import '../../campaign_rules/presentation/state_providers.dart';
import 'widgets/character_hud_bar.dart';
import 'widgets/action_queue_card.dart';
import 'widgets/storyline_guidance_card.dart';
import 'widgets/speech_input_widget.dart';

class DmCockpitScreen extends ConsumerWidget {
  const DmCockpitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final queue = ref.watch(pendingActionQueueProvider);
    final locationMeta = LocationMetadata.all[gameState.location]!;

    return Scaffold(
      backgroundColor: AppTheme.obsidian,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.bronzePrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.bronzePrimary.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.shield_moon, size: 18, color: AppTheme.bronzePrimary),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SutraDhar Cockpit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.parchment,
                  ),
                ),
                Text(
                  '11th C. Chola • ${locationMeta.name}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.parchmentMuted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Resource HUD in AppBar
          _buildResourceChip(
            icon: Icons.local_fire_department,
            label: 'Threat ${gameState.threatLevel}/6',
            color: gameState.threatLevel >= 4
                ? AppTheme.terracotta
                : (gameState.threatLevel >= 2 ? AppTheme.bronzePrimary : AppTheme.verdigris),
            onTap: () => _showThreatAdjustDialog(context, ref, gameState.threatLevel),
          ),
          const SizedBox(width: 8),
          _buildResourceChip(
            icon: Icons.inventory_2_outlined,
            label: '${gameState.supplies} Rations',
            color: gameState.supplies <= 2 ? AppTheme.terracotta : AppTheme.bronzeLight,
            onTap: () => ref.read(gameStateProvider.notifier).adjustSupplies(-1),
          ),
          const SizedBox(width: 8),
          _buildResourceChip(
            icon: Icons.monetization_on_outlined,
            label: '${gameState.gold} Gold',
            color: AppTheme.bronzePrimary,
            onTap: () => ref.read(gameStateProvider.notifier).adjustGold(1),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Live 4-Character Tracking HUD Bar
              const CharacterHudBar(),
              const SizedBox(height: 16),

              // 2. Pending AI Proposed Actions Queue (if any actions pending)
              if (queue.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pending_actions, size: 18, color: AppTheme.bronzePrimary),
                        const SizedBox(width: 8),
                        Text(
                          'ACTION REVIEW QUEUE (${queue.length} PENDING)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.bronzeLight,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => ref.read(pendingActionQueueProvider.notifier).clear(),
                      child: const Text('Dismiss All', style: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...queue.map((delta) => ActionQueueCard(delta: delta)),
                const SizedBox(height: 12),
              ],

              // 3. Speech & Physical Dice Roll Input Box
              const SpeechInputWidget(),
              const SizedBox(height: 16),

              // 4. Storyline Guidance Card (Canonical Bible Directives & Whispers)
              const StorylineGuidanceCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.graniteCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThreatAdjustDialog(BuildContext context, WidgetRef ref, int currentThreat) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.graniteCard,
          title: const Text('Adjust Threat Level (0–6)', style: TextStyle(color: AppTheme.parchment)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Current Threat: $currentThreat',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.terracotta),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppTheme.graniteDark),
                    onPressed: () {
                      ref.read(gameStateProvider.notifier).adjustThreat(-1);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.remove, color: AppTheme.verdigris),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppTheme.graniteDark),
                    onPressed: () {
                      ref.read(gameStateProvider.notifier).adjustThreat(1);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add, color: AppTheme.terracotta),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
