import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/party_setup_model.dart';
import '../controllers/setup_controller.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.graniteDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.bronzePrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'CAMPAIGN SETUP',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.bronzeLight,
                fontSize: 16,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppTheme.obsidian,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step 1: Character Roster Section
                        _buildSectionHeader(
                          context,
                          stepNumber: '1',
                          title: 'Assemble Your Party',
                          subtitle: 'Select exactly 4 characters from the 6 Chola archetypes.',
                          trailing: _buildSelectionCounter(setupState.selectedCharacterIds.length),
                        ),
                        const SizedBox(height: 16),
                        _buildCharacterGrid(context, ref, setupState, controller),

                        const SizedBox(height: 36),

                        // Step 2: Game Mode & Pacing
                        _buildSectionHeader(
                          context,
                          stepNumber: '2',
                          title: 'Session Configuration',
                          subtitle: 'Set your companion app role and intended play duration.',
                        ),
                        const SizedBox(height: 16),
                        _buildGameModeSelector(context, setupState, controller),
                        const SizedBox(height: 14),
                        _buildPacingSelector(context, setupState, controller),

                        const SizedBox(height: 36),

                        // Step 3: Act I Strategic Departure
                        _buildSectionHeader(
                          context,
                          stepNumber: '3',
                          title: 'Thanjavur Departure Choice',
                          subtitle: 'Decide your preparation package before leaving the imperial court.',
                        ),
                        const SizedBox(height: 16),
                        _buildDepartureChoices(context, setupState, controller),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Persistent Bottom Action Bar
            _buildLaunchBar(context, ref, setupState, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.bronzePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: AppTheme.obsidian,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      color: AppTheme.parchment,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                    ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildSelectionCounter(int count) {
    final isComplete = count == 4;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isComplete
            ? AppTheme.verdigris.withValues(alpha: 0.2)
            : AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isComplete ? AppTheme.verdigris : AppTheme.bronzePrimary,
          width: 1.5,
        ),
      ),
      child: Text(
        '$count / 4 SELECTED',
        style: TextStyle(
          color: isComplete ? AppTheme.verdigris : AppTheme.bronzeLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCharacterGrid(
    BuildContext context,
    WidgetRef ref,
    SessionConfiguration setupState,
    SetupController controller,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 650 ? 3 : (constraints.maxWidth > 420 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: crossAxisCount == 1 ? 2.4 : 0.82,
          ),
          itemCount: CharacterProfile.allArchetypes.length,
          itemBuilder: (context, index) {
            final profile = CharacterProfile.allArchetypes[index];
            final isSelected = setupState.selectedCharacterIds.contains(profile.id);
            final playerName = setupState.playerNames[profile.id] ?? '';

            return _buildCharacterCard(
              context,
              profile: profile,
              isSelected: isSelected,
              playerName: playerName,
              onTap: () => controller.toggleCharacter(profile.id),
              onNameChanged: (val) => controller.setPlayerName(profile.id, val),
            );
          },
        );
      },
    );
  }

  Widget _buildCharacterCard(
    BuildContext context, {
    required CharacterProfile profile,
    required bool isSelected,
    required String playerName,
    required VoidCallback onTap,
    required ValueChanged<String> onNameChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E273A) : AppTheme.graniteCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppTheme.bronzePrimary : AppTheme.graniteBorder,
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.bronzePrimary.withValues(alpha: 0.25),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Role Badge & Select Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.obsidian,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.graniteBorder),
                      ),
                      child: Text(
                        'HP: ${profile.hp}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.bronzeLight,
                        ),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppTheme.bronzePrimary : AppTheme.obsidian,
                        border: Border.all(
                          color: isSelected ? AppTheme.bronzeLight : AppTheme.graniteBorder,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: AppTheme.obsidian)
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Name & Epithet
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        color: isSelected ? AppTheme.bronzeLight : AppTheme.parchment,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.role,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.parchmentMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // Compact Attribute Pills
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _buildStatPill('MGT', profile.might),
                    _buildStatPill('AGI', profile.agility),
                    _buildStatPill('KNOW', profile.knowledge),
                    _buildStatPill('INF', profile.influence),
                    _buildStatPill('SEA', profile.seamanship),
                  ],
                ),

                const Spacer(),

                // Player Name Field (Visible when selected)
                if (isSelected) ...[
                  TextField(
                    onChanged: onNameChanged,
                    controller: TextEditingController(text: playerName)
                      ..selection = TextSelection.collapsed(offset: playerName.length),
                    style: const TextStyle(fontSize: 12, color: AppTheme.parchment),
                    decoration: InputDecoration(
                      hintText: 'Player Name (e.g. Aryan)',
                      hintStyle: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted.withValues(alpha: 0.6)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      filled: true,
                      fillColor: AppTheme.obsidian,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppTheme.graniteBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppTheme.bronzePrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                // View Details Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _showCharacterDetails(context, profile),
                    child: const Text(
                      'View Lore & Abilities',
                      style: TextStyle(fontSize: 11, color: AppTheme.bronzePrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.obsidian,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label +$value',
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.parchmentMuted),
      ),
    );
  }

  Widget _buildGameModeSelector(
    BuildContext context,
    SessionConfiguration setupState,
    SetupController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildChoiceCard(
            context,
            icon: Icons.shield_outlined,
            title: 'Assisted GM Mode',
            description: 'A human GM operates the private DM Cockpit with voice PTT and the Accept/Reject queue.',
            isSelected: setupState.gameMode == GameMode.assistedGm,
            onTap: () => controller.setGameMode(GameMode.assistedGm),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildChoiceCard(
            context,
            icon: Icons.auto_awesome,
            title: 'Autonomous Co-DM',
            description: 'No human GM. The app acts as the full tabletop narrator, voice parser, and state manager.',
            isSelected: setupState.gameMode == GameMode.autonomousCoDm,
            onTap: () => controller.setGameMode(GameMode.autonomousCoDm),
          ),
        ),
      ],
    );
  }

  Widget _buildPacingSelector(
    BuildContext context,
    SessionConfiguration setupState,
    SetupController controller,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildChoiceCard(
            context,
            icon: Icons.hourglass_full_rounded,
            title: 'Full Campaign (30–45m)',
            description: 'The complete 12-chapter mystery with all exploration branches and encounters.',
            isSelected: setupState.sessionPacing == SessionPacing.fullCampaign,
            onTap: () => controller.setSessionPacing(SessionPacing.fullCampaign),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildChoiceCard(
            context,
            icon: Icons.timer_outlined,
            title: 'Judge Demo (5–10m)',
            description: 'Fast-paced demonstration mode skipping travel turns directly to core decision nodes.',
            isSelected: setupState.sessionPacing == SessionPacing.quickDemo,
            onTap: () => controller.setSessionPacing(SessionPacing.quickDemo),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartureChoices(
    BuildContext context,
    SessionConfiguration setupState,
    SetupController controller,
  ) {
    return Column(
      children: [
        _buildRadioOption(
          context,
          title: 'Choice A: Pack Heavy Rations',
          consequence: 'Start with +2 Supplies (10 total), but delay causes Threat to start at 1.',
          isSelected: setupState.departureChoice == Act1DepartureChoice.extraSupplies,
          onTap: () => controller.setDepartureChoice(Act1DepartureChoice.extraSupplies),
        ),
        const SizedBox(height: 8),
        _buildRadioOption(
          context,
          title: 'Choice B: Requisition Royal Court Seal',
          consequence: 'Gain +2 on social checks with imperial officials, but port smugglers become suspicious.',
          isSelected: setupState.departureChoice == Act1DepartureChoice.royalSeal,
          onTap: () => controller.setDepartureChoice(Act1DepartureChoice.royalSeal),
        ),
        const SizedBox(height: 8),
        _buildRadioOption(
          context,
          title: 'Choice C: Swift Departure (Recommended)',
          consequence: 'Depart at dawn with standard provisions: 8 Supplies, 3 Gold, Threat at 0.',
          isSelected: setupState.departureChoice == Act1DepartureChoice.swiftDeparture,
          onTap: () => controller.setDepartureChoice(Act1DepartureChoice.swiftDeparture),
        ),
        const SizedBox(height: 8),
        _buildRadioOption(
          context,
          title: 'Choice D: Investigate Lost Crew Dossiers',
          consequence: 'Begin Nagapattinam with +1 Clue regarding the ship navigator\'s secret route warning.',
          isSelected: setupState.departureChoice == Act1DepartureChoice.crewRecords,
          onTap: () => controller.setDepartureChoice(Act1DepartureChoice.crewRecords),
        ),
      ],
    );
  }

  Widget _buildChoiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E273A) : AppTheme.graniteCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.bronzePrimary : AppTheme.graniteBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: isSelected ? AppTheme.bronzeLight : AppTheme.parchmentMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.bronzeLight : AppTheme.parchment,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
    required String title,
    required String consequence,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E273A) : AppTheme.graniteCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.bronzePrimary : AppTheme.graniteBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected ? AppTheme.bronzePrimary : AppTheme.parchmentMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.bronzeLight : AppTheme.parchment,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    consequence,
                    style: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaunchBar(
    BuildContext context,
    WidgetRef ref,
    SessionConfiguration setupState,
    SetupController controller,
  ) {
    final canLaunch = setupState.isValid;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.graniteDark,
        border: const Border(
          top: BorderSide(color: AppTheme.graniteBorder, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    canLaunch
                        ? 'Party Ready (${setupState.selectedCharacterIds.length}/4 Selected)'
                        : 'Select 4 Characters to Begin',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: canLaunch ? AppTheme.verdigris : AppTheme.terracotta,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Physical battlemap & 2d6 dice should be ready.',
                    style: TextStyle(fontSize: 11, color: AppTheme.parchmentMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: canLaunch
                    ? () async {
                        final success = await controller.saveAndStartSession();
                        if (success && context.mounted) {
                          Navigator.of(context).pop(); // Returns to HomeScreen which now shows "Continue"
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Campaign initialized! Ready to embark on The Lost Ship.'),
                              backgroundColor: AppTheme.graniteCard,
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.sailing_rounded, size: 20),
                label: const Text('EMBARK ON MISSION'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCharacterDetails(BuildContext context, CharacterProfile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.graniteDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 22,
                        color: AppTheme.bronzeLight,
                      ),
                ),
                Text(
                  'Base HP: ${profile.hp}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.parchment),
                ),
              ],
            ),
            Text(profile.epithet, style: TextStyle(fontSize: 13, color: AppTheme.parchmentMuted, fontStyle: FontStyle.italic)),
            const Divider(color: AppTheme.graniteBorder, height: 24),
            const Text('SIGNATURE ABILITIES (2d6 System):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.bronzePrimary)),
            const SizedBox(height: 6),
            ...profile.abilities.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppTheme.bronzePrimary)),
                      Expanded(child: Text(a, style: const TextStyle(fontSize: 13, color: AppTheme.parchment))),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            const Text('STARTING EQUIPMENT:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.bronzePrimary)),
            const SizedBox(height: 6),
            Text(profile.equipment.join(' • '), style: const TextStyle(fontSize: 13, color: AppTheme.parchmentMuted)),
          ],
        ),
      ),
    );
  }
}
