import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../setup/domain/models/party_setup_model.dart';
import '../../../setup/presentation/screens/setup_screen.dart';
import '../../../dm_cockpit/presentation/dm_cockpit_screen.dart';
import '../../../campaign_rules/presentation/state_providers.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(homeSessionProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.2,
            colors: [
              Color(0xFF1E2738), // Subtle warm ambient center
              AppTheme.graniteDark,
              AppTheme.obsidian,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Embellished Header Crest
                    _buildHeaderCrest(context),
                    const SizedBox(height: 16),

                    // Main Title
                    Text(
                      'SUTRADHAR',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.bronzeLight,
                            shadows: [
                              Shadow(
                                color: AppTheme.bronzePrimary.withValues(alpha: 0.5),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'CHOLA AI-TTRPG COMPANION ENGINE',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.parchmentMuted,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Campaign Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.graniteCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.bronzePrimary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.explore_outlined,
                              size: 14, color: AppTheme.bronzePrimary),
                          const SizedBox(width: 8),
                          Text(
                            'THE LOST SHIP • 11TH-CENTURY CHOLA',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.bronzeLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Dynamic Main Action Section
                    sessionAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppTheme.bronzePrimary),
                      ),
                      error: (err, _) => _buildErrorCard(context, ref, err.toString()),
                      data: (session) {
                        if (session == null) {
                          // First Time Flow: Start Playing
                          return _buildFirstTimeCard(context);
                        } else {
                          // Returning Session: Continue Game
                          return _buildContinueSessionCard(context, ref, session);
                        }
                      },
                    ),

                    const SizedBox(height: 48),

                    // Physical Tabletop Reminder Footer
                    _buildTabletopReminder(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCrest(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.graniteCard,
        border: Border.all(color: AppTheme.bronzePrimary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bronzePrimary.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.sailing_rounded,
          color: AppTheme.bronzeLight,
          size: 44,
        ),
      ),
    );
  }

  Widget _buildFirstTimeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.graniteBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Begin Your Campaign',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 20,
                  color: AppTheme.parchment,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Unite the tactile joy of your physical battlemap, character cards, and 2d6 dice with an adaptive AI Game Master.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: const Text('START PLAYING'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueSessionCard(
    BuildContext context,
    WidgetRef ref,
    SessionConfiguration session,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.bronzePrimary.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.bronzePrimary.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.verdigris.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.verdigris, width: 1),
                ),
                child: const Text(
                  'CAMPAIGN IN PROGRESS',
                  style: TextStyle(
                    color: AppTheme.verdigris,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: AppTheme.parchmentMuted),
                tooltip: 'Reset Campaign',
                onPressed: () => _confirmReset(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'The Lost Ship: Coromandel Coast',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 17,
                  color: AppTheme.parchment,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Active Party (4 Heroes):',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.bronzeLight,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: session.selectedCharacterIds.map((id) {
              final profile = CharacterProfile.allArchetypes.firstWhere(
                (p) => p.id == id,
                orElse: () => CharacterProfile.allArchetypes.first,
              );
              final playerName = session.playerNames[id];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.graniteDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.graniteBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_pin, size: 14, color: AppTheme.bronzePrimary),
                    const SizedBox(width: 6),
                    Text(
                      playerName != null && playerName.isNotEmpty
                          ? '${profile.name} ($playerName)'
                          : profile.name,
                      style: const TextStyle(fontSize: 12, color: AppTheme.parchment),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(gameStateProvider.notifier).initFromSession(session);
                ref.read(partyCharactersProvider.notifier).initFromSession(session);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DmCockpitScreen()),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('CONTINUE SESSION'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                );
              },
              child: const Text('START NEW ADVENTURE'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, WidgetRef ref, String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.terracotta),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.terracotta, size: 36),
          const SizedBox(height: 8),
          Text('Error loading saved campaign', style: TextStyle(color: AppTheme.terracotta)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => ref.read(homeSessionProvider.notifier).checkSavedSession(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletopReminder(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.graniteDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.graniteBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.casino_outlined, size: 18, color: AppTheme.bronzePrimary),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Physical Setup: Place 24"x36" map, character cards & two 6-sided dice on the table.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.graniteCard,
        title: const Text('Reset Campaign?', style: TextStyle(color: AppTheme.bronzeLight)),
        content: const Text(
          'Are you sure you want to clear the active campaign? All progress, clue discoveries, and character states will be erased.',
          style: TextStyle(color: AppTheme.parchment),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.parchmentMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.terracotta),
            onPressed: () {
              ref.read(homeSessionProvider.notifier).clearSession();
              Navigator.of(ctx).pop();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
