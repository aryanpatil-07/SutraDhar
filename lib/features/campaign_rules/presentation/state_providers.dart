import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/campaign_constants.dart';
import '../../setup/domain/models/party_setup_model.dart';
import '../domain/models/character_model.dart';
import '../domain/models/game_state_model.dart';
import '../domain/rules_engine.dart';

// State Notifier for Game State (Location, Threat, Supplies, Gold, Clues)
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, ActiveGameState>((ref) {
  return GameStateNotifier();
});

class GameStateNotifier extends StateNotifier<ActiveGameState> {
  GameStateNotifier()
      : super(const ActiveGameState(
          location: CampaignLocation.thanjavur,
          threatLevel: 0,
          supplies: 8,
          gold: 3,
        ));

  void initFromSession(SessionConfiguration config) {
    int startingThreat = 0;
    int startingSupplies = 8;
    int startingGold = 3;
    final startingClues = <String>[];

    switch (config.departureChoice) {
      case Act1DepartureChoice.extraSupplies:
        startingSupplies = 10;
        startingThreat = 1; // Delay costs threat
        break;
      case Act1DepartureChoice.royalSeal:
        startingClues.add('imperial_court_seal');
        break;
      case Act1DepartureChoice.swiftDeparture:
        // Baseline 8 supplies, 3 gold, threat 0
        break;
      case Act1DepartureChoice.crewRecords:
        startingClues.add('navigator_warning_memo');
        break;
    }

    state = ActiveGameState(
      location: CampaignLocation.thanjavur,
      threatLevel: startingThreat,
      supplies: startingSupplies,
      gold: startingGold,
      discoveredClueIds: startingClues,
    );
  }

  void updateState(ActiveGameState newState) {
    state = newState;
  }

  void adjustThreat(int delta) {
    state = state.copyWith(threatLevel: (state.threatLevel + delta).clamp(0, 6));
  }

  void adjustSupplies(int delta) {
    state = state.copyWith(supplies: (state.supplies + delta).clamp(0, 999));
  }

  void adjustGold(int delta) {
    state = state.copyWith(gold: (state.gold + delta).clamp(0, 999));
  }

  void setLocation(CampaignLocation newLocation) {
    state = state.copyWith(location: newLocation);
  }
}

// State Notifier for 4 Party Characters
final partyCharactersProvider =
    StateNotifierProvider<CharactersNotifier, Map<String, ActiveCharacter>>((ref) {
  return CharactersNotifier();
});

class CharactersNotifier extends StateNotifier<Map<String, ActiveCharacter>> {
  CharactersNotifier() : super({});

  void initFromSession(SessionConfiguration config) {
    final map = <String, ActiveCharacter>{};
    for (final id in config.selectedCharacterIds) {
      final profile = CharacterProfile.allArchetypes.firstWhere(
        (p) => p.id == id,
        orElse: () => CharacterProfile.allArchetypes.first,
      );
      final playerName = config.playerNames[id] ?? '';

      map[id] = ActiveCharacter(
        id: profile.id,
        name: profile.name,
        role: profile.role,
        playerName: playerName,
        currentHp: profile.hp,
        maxHp: profile.hp,
        might: profile.might,
        agility: profile.agility,
        knowledge: profile.knowledge,
        influence: profile.influence,
        seamanship: profile.seamanship,
        stamina: 2,
        insightTokens: profile.id == 'kalviyalar' ? 2 : 0,
        influenceTokens: profile.id == 'thoodhuvar' ? 2 : 0,
        inventory: profile.equipment,
      );
    }
    state = map;
  }

  void setCharacters(Map<String, ActiveCharacter> newMap) {
    state = newMap;
  }

  void adjustHp(String characterId, int delta) {
    if (state.containsKey(characterId)) {
      final char = state[characterId]!;
      final updated = char.copyWith(currentHp: (char.currentHp + delta).clamp(0, char.maxHp));
      state = {...state, characterId: updated};
    }
  }

  void adjustStamina(String characterId, int delta) {
    if (state.containsKey(characterId)) {
      final char = state[characterId]!;
      final updated = char.copyWith(stamina: (char.stamina + delta).clamp(0, 99));
      state = {...state, characterId: updated};
    }
  }
}

// State Notifier for Pending Action Queue (DM Review Queue)
final pendingActionQueueProvider =
    StateNotifierProvider<ActionQueueNotifier, List<ProposedActionDelta>>((ref) {
  return ActionQueueNotifier();
});

class ActionQueueNotifier extends StateNotifier<List<ProposedActionDelta>> {
  ActionQueueNotifier() : super([]);

  void enqueue(ProposedActionDelta delta) {
    state = [...state, delta];
  }

  void remove(ProposedActionDelta delta) {
    state = state.where((d) => d != delta).toList();
  }

  void clear() {
    state = [];
  }
}
