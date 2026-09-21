import 'models/character_model.dart';
import 'models/game_state_model.dart';
import '../../../core/constants/campaign_constants.dart';

enum ActionType {
  skillCheck,
  combatAction,
  travel,
  investigation,
  dialogue,
  rest,
}

class CheckEvaluation {
  final String attribute;
  final int die1;
  final int die2;
  final int attributeModifier;
  final int situationalBonus;
  final int targetDc;

  const CheckEvaluation({
    required this.attribute,
    required this.die1,
    required this.die2,
    required this.attributeModifier,
    this.situationalBonus = 0,
    required this.targetDc,
  });

  int get diceSum => die1 + die2;
  int get totalScore => diceSum + attributeModifier + situationalBonus;
  bool get isCriticalSuccess => die1 == 6 && die2 == 6; // Natural 12
  bool get isCriticalFailure => die1 == 1 && die2 == 1; // Natural 2
  bool get isSuccess => isCriticalSuccess || (!isCriticalFailure && totalScore >= targetDc);

  String get formulaSummary =>
      '[$die1 + $die2] ($diceSum) + Mod: $attributeModifier' +
      (situationalBonus != 0 ? ' + Bonus: $situationalBonus' : '') +
      ' = $totalScore vs DC $targetDc';
}

class ProposedActionDelta {
  final ActionType actionType;
  final String actingCharacterId;
  final CheckEvaluation? checkEvaluation;
  final CampaignLocation? targetLocation;
  final Map<String, int> characterHpDeltas;
  final Map<String, int> characterStaminaDeltas;
  final int threatDelta;
  final int suppliesDelta;
  final int goldDelta;
  final List<String> newClues;
  final Map<String, NpcTrustLevel> npcTrustUpdates;
  final String narration;
  final String gmSecretNote;
  final String? ambientTrack;
  final String? sfxCue;

  const ProposedActionDelta({
    required this.actionType,
    this.actingCharacterId = 'party',
    this.checkEvaluation,
    this.targetLocation,
    this.characterHpDeltas = const {},
    this.characterStaminaDeltas = const {},
    this.threatDelta = 0,
    this.suppliesDelta = 0,
    this.goldDelta = 0,
    this.newClues = const [],
    this.npcTrustUpdates = const {},
    required this.narration,
    this.gmSecretNote = '',
    this.ambientTrack,
    this.sfxCue,
  });
}

class RulesEngine {
  /// Evaluates a physical 2d6 roll against a target DC.
  static CheckEvaluation evaluate2d6({
    required String attribute,
    required int die1,
    required int die2,
    required int modifier,
    int situationalBonus = 0,
    required int targetDc,
  }) {
    return CheckEvaluation(
      attribute: attribute,
      die1: die1.clamp(1, 6),
      die2: die2.clamp(1, 6),
      attributeModifier: modifier,
      situationalBonus: situationalBonus,
      targetDc: targetDc,
    );
  }

  /// Deterministically applies a validated action delta onto the game state and characters.
  static ({
    ActiveGameState updatedGameState,
    Map<String, ActiveCharacter> updatedCharacters,
  }) applyActionDelta({
    required ActiveGameState currentGameState,
    required Map<String, ActiveCharacter> currentCharacters,
    required ProposedActionDelta delta,
  }) {
    // 1. Update Game State Resources with Invariant Clamping
    final updatedThreat = (currentGameState.threatLevel + delta.threatDelta).clamp(0, 6);
    final updatedSupplies = (currentGameState.supplies + delta.suppliesDelta).clamp(0, 999);
    final updatedGold = (currentGameState.gold + delta.goldDelta).clamp(0, 999);

    // 2. Accumulate Discovered Clues
    final updatedClues = List<String>.from(currentGameState.discoveredClueIds);
    for (final clue in delta.newClues) {
      if (!updatedClues.contains(clue)) {
        updatedClues.add(clue);
      }
    }

    // 3. Update NPC Trust Map
    final updatedTrust = Map<String, NpcTrustLevel>.from(currentGameState.npcTrust);
    delta.npcTrustUpdates.forEach((npcId, trust) {
      updatedTrust[npcId] = trust;
    });

    // 4. Update Location if travel occurred
    final updatedLocation = delta.targetLocation ?? currentGameState.location;

    final updatedGameState = currentGameState.copyWith(
      location: updatedLocation,
      turnNumber: currentGameState.turnNumber + 1,
      threatLevel: updatedThreat,
      supplies: updatedSupplies,
      gold: updatedGold,
      discoveredClueIds: updatedClues,
      npcTrust: updatedTrust,
      activeAmbientTrack: delta.ambientTrack ?? currentGameState.activeAmbientTrack,
    );

    // 5. Update Characters' HP and Stamina
    final updatedCharacters = Map<String, ActiveCharacter>.from(currentCharacters);
    delta.characterHpDeltas.forEach((charId, hpDelta) {
      if (updatedCharacters.containsKey(charId)) {
        final char = updatedCharacters[charId]!;
        updatedCharacters[charId] = char.copyWith(
          currentHp: (char.currentHp + hpDelta).clamp(0, char.maxHp),
        );
      }
    });

    delta.characterStaminaDeltas.forEach((charId, staminaDelta) {
      if (updatedCharacters.containsKey(charId)) {
        final char = updatedCharacters[charId]!;
        updatedCharacters[charId] = char.copyWith(
          stamina: (char.stamina + staminaDelta).clamp(0, 99),
        );
      }
    });

    return (
      updatedGameState: updatedGameState,
      updatedCharacters: updatedCharacters,
    );
  }
}
