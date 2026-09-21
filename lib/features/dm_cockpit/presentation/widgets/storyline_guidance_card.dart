import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/campaign_constants.dart';
import '../../../campaign_rules/presentation/state_providers.dart';
import '../../../ai_orchestration/domain/storyline_guidance_engine.dart';

class StorylineGuidanceCard extends ConsumerStatefulWidget {
  const StorylineGuidanceCard({super.key});

  @override
  ConsumerState<StorylineGuidanceCard> createState() => _StorylineGuidanceCardState();
}

class _StorylineGuidanceCardState extends ConsumerState<StorylineGuidanceCard> {
  bool _whispersExpanded = true;
  bool _directivesExpanded = true;
  bool _cluesExpanded = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final guidance = StorylineGuidanceEngine.generateGuidance(gameState: gameState);
    final locationMeta = LocationMetadata.all[gameState.location]!;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.bronzePrimary.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bronzePrimary.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              border: Border(bottom: BorderSide(color: AppTheme.bronzePrimary.withValues(alpha: 0.3))),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_stories, size: 20, color: AppTheme.bronzePrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guidance.chapterTitle.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.bronzeLight,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        'Location: ${locationMeta.name} • Suggested Level: ${locationMeta.suggestedPartyLevel}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.parchmentMuted),
                      ),
                    ],
                  ),
                ),
                // Location Switcher Dropdown for GM
                _buildLocationDropdown(context, gameState.location),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Threat Warning Alert
                if (guidance.threatWarning != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.terracotta.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.terracotta.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, size: 18, color: AppTheme.terracotta),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            guidance.threatWarning!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.terracotta,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Current Objective Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidian,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.graniteBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.flag_outlined, size: 18, color: AppTheme.verdigris),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CURRENT OBJECTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.verdigris,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              guidance.currentGoal,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.parchment,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Atmospheric Narration (Prose for DM to set the scene)
                const Text(
                  'Atmospheric Scene Description:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.parchmentMuted),
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
                    '"${guidance.atmosphericNarrationHint}"',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.parchment,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Expandable: GM Directives
                _buildAccordionSection(
                  title: 'STORYLINE DIRECTIVES FOR GM',
                  icon: Icons.lightbulb_outline,
                  iconColor: AppTheme.bronzeLight,
                  isExpanded: _directivesExpanded,
                  onToggle: () => setState(() => _directivesExpanded = !_directivesExpanded),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: guidance.gmDirectives.map((d) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppTheme.bronzePrimary, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                d,
                                style: const TextStyle(fontSize: 12, color: AppTheme.parchment, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // Expandable: Secret DM Whispers
                _buildAccordionSection(
                  title: 'SECRET DM WHISPERS & HIDDEN AGENDAS',
                  icon: Icons.visibility_off_outlined,
                  iconColor: AppTheme.terracotta,
                  isExpanded: _whispersExpanded,
                  onToggle: () => setState(() => _whispersExpanded = !_whispersExpanded),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: guidance.secretWhispers.map((w) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.terracotta.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.terracotta.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lock, size: 14, color: AppTheme.terracotta),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                w,
                                style: const TextStyle(fontSize: 11.5, color: AppTheme.parchment, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // Expandable: Unrevealed Clues
                _buildAccordionSection(
                  title: 'LOCATION CLUES (${guidance.unrevealedClues.length} Unrevealed)',
                  icon: Icons.search,
                  iconColor: AppTheme.verdigris,
                  isExpanded: _cluesExpanded,
                  onToggle: () => setState(() => _cluesExpanded = !_cluesExpanded),
                  content: guidance.unrevealedClues.isEmpty
                      ? const Text(
                          'All key clues at this location have been discovered!',
                          style: TextStyle(fontSize: 12, color: AppTheme.verdigris, fontStyle: FontStyle.italic),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: guidance.unrevealedClues.map((c) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.obsidian,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.graniteBorder),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.help_outline, size: 12, color: AppTheme.bronzePrimary),
                                  const SizedBox(width: 6),
                                  Text(
                                    c.replaceAll('_', ' ').toUpperCase(),
                                    style: const TextStyle(fontSize: 10, color: AppTheme.parchmentMuted),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.graniteDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.graniteBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: iconColor),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppTheme.parchmentMuted,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown(BuildContext context, CampaignLocation current) {
    return PopupMenuButton<CampaignLocation>(
      initialValue: current,
      tooltip: 'Change Location',
      color: AppTheme.graniteCard,
      onSelected: (loc) {
        ref.read(gameStateProvider.notifier).setLocation(loc);
      },
      itemBuilder: (context) {
        return CampaignLocation.values.map((loc) {
          final isCurr = loc == current;
          return PopupMenuItem<CampaignLocation>(
            value: loc,
            child: Row(
              children: [
                Icon(
                  isCurr ? Icons.place : Icons.place_outlined,
                  size: 16,
                  color: isCurr ? AppTheme.bronzePrimary : AppTheme.parchmentMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  LocationMetadata.all[loc]!.name,
                  style: TextStyle(
                    color: isCurr ? AppTheme.bronzePrimary : AppTheme.parchment,
                    fontWeight: isCurr ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.obsidian,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.bronzePrimary.withValues(alpha: 0.5)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_location_alt, size: 14, color: AppTheme.bronzePrimary),
            SizedBox(width: 4),
            Text('Travel', style: TextStyle(fontSize: 11, color: AppTheme.bronzeLight, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
