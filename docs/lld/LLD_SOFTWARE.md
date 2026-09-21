# Low-Level Design (LLD) — Software Architecture
## SutraDhar: Chola AI-TTRPG Companion Engine

| Document Version | Implementation State | Language / Framework | Target DB / Audio |
| :--- | :--- | :--- | :--- |
| **v1.0.0** | Production Reference | Flutter (Dart 3.x) / Riverpod | Drift (SQLite) / `just_audio` |

---

## 1. Project Directory Structure

The SutraDhar codebase adheres to a **feature-first, clean architecture** pattern. This isolates domain business rules from external frameworks (audio, STT, database, LLM APIs).

```
lib/
├── core/
│   ├── audio/                     # just_audio dual-channel audio managers & crossfaders
│   │   ├── ambient_controller.dart
│   │   ├── audio_manager.dart
│   │   └── sfx_controller.dart
│   ├── constants/                 # Asset paths, sound maps, campaign constants
│   ├── database/                  # Drift SQLite ORM, migrations, and DAOs
│   │   ├── app_database.dart
│   │   ├── app_database.g.dart
│   │   └── tables.dart
│   ├── errors/                    # Failure types, exceptions, schema errors
│   ├── network/                   # HTTP client, Whisper API & LLM REST connectors
│   └── utils/                     # Dice math, formatting, logging
├── features/
│   ├── ai_orchestration/          # Prompt assembling, JSON schema validation, LLM client
│   │   ├── data/
│   │   │   ├── ai_repository.dart
│   │   │   └── llm_schemas.dart
│   │   └── domain/
│   │       └── state_delta_parser.dart
│   ├── audio_atmosphere/          # Audio playback state & asset mapping
│   │   └── presentation/
│   │       └── audio_control_widget.dart
│   ├── campaign_rules/            # Deterministic rules engine, state invariants, DC math
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── character_model.dart
│   │   │   │   ├── game_state_model.dart
│   │   │   │   ├── npc_model.dart
│   │   │   │   └── quest_clue_model.dart
│   │   │   └── rules_engine.dart
│   │   └── presentation/
│   │       └── state_providers.dart
│   ├── dm_cockpit/                # Private GM interface, Accept/Reject queue, PTT
│   │   └── presentation/
│   │       ├── action_queue_card.dart
│   │       ├── dm_cockpit_screen.dart
│   │       └── push_to_talk_button.dart
│   ├── speech_to_text/            # Audio recording, PTT buffers, Whisper STT integration
│   │   ├── data/
│   │   │   └── whisper_service.dart
│   │   └── domain/
│   │       └── speech_controller.dart
│   └── tabletop_view/             # Public player-facing screen, interactive map, HUD
│       └── presentation/
│           ├── interactive_map_canvas.dart
│           ├── party_hud_bar.dart
│           └── tabletop_screen.dart
└── main.dart                      # App entry point, Multi-screen / provider initialization
```

---

## 2. Riverpod State Models & Domain Architecture

All domain models are immutable and serialize cleanly to JSON for local persistence and LLM interoperability.

### 2.1 Game State Model (`GameState`)

```dart
enum CampaignLocation {
  thanjavur,
  nagapattinam,
  coastalVillage,
  oldRoad,
  openSea,
  island,
  ruins,
}

class GameState {
  final String campaignId;
  final int turnNumber;
  final CampaignLocation currentLocation;
  final int threatLevel; // Clamped between 0 and 6
  final int supplies;    // Decrements with travel and failures
  final int gold;        // Party currency
  final List<String> discoveredClueIds;
  final Map<String, NpcTrustLevel> npcTrust;
  final bool isCombatActive;
  final List<String> combatInitiativeOrder;
  final String? activeAmbientTrack;

  const GameState({
    required this.campaignId,
    required this.turnNumber,
    required this.currentLocation,
    required this.threatLevel,
    required this.supplies,
    required this.gold,
    required this.discoveredClueIds,
    required this.npcTrust,
    required this.isCombatActive,
    required this.combatInitiativeOrder,
    this.activeAmbientTrack,
  });

  GameState copyWith({
    int? turnNumber,
    CampaignLocation? currentLocation,
    int? threatLevel,
    int? supplies,
    int? gold,
    List<String>? discoveredClueIds,
    Map<String, NpcTrustLevel>? npcTrust,
    bool? isCombatActive,
    List<String>? combatInitiativeOrder,
    String? activeAmbientTrack,
  }) {
    return GameState(
      campaignId: campaignId,
      turnNumber: turnNumber ?? this.turnNumber,
      currentLocation: currentLocation ?? this.currentLocation,
      threatLevel: (threatLevel ?? this.threatLevel).clamp(0, 6),
      supplies: (supplies ?? this.supplies).clamp(0, 999),
      gold: (gold ?? this.gold).clamp(0, 999),
      discoveredClueIds: discoveredClueIds ?? this.discoveredClueIds,
      npcTrust: npcTrust ?? this.npcTrust,
      isCombatActive: isCombatActive ?? this.isCombatActive,
      combatInitiativeOrder: combatInitiativeOrder ?? this.combatInitiativeOrder,
      activeAmbientTrack: activeAmbientTrack ?? this.activeAmbientTrack,
    );
  }
}
```

### 2.2 Character Model (`CharacterState`)

```dart
enum CharacterClass {
  kavalan,        // Guardian
  vetan,          // Scout
  vaniyan,        // Merchant
  kalviyalar,     // Scholar
  marakkalam,     // Navigator
  thoodhuvar,     // Envoy
}

class CharacterState {
  final String id;
  final String name;
  final CharacterClass characterClass;
  final int currentHp;
  final int maxHp;
  
  // Core Attributes (2d6 Modifiers)
  final int might;
  final int agility;
  final int knowledge;
  final int influence;
  final int seamanship;

  // Class-specific resource pools
  final int stamina;         // Kavalan & Vetan (Combat & maneuvers)
  final int insightTokens;   // Kalviyalar (Lore discovery)
  final int influenceTokens; // Thoodhuvar (Diplomatic immunity & rerolls)

  final List<String> inventory;
  final bool isIncapacitated;

  const CharacterState({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.currentHp,
    required this.maxHp,
    required this.might,
    required this.agility,
    required this.knowledge,
    required this.influence,
    required this.seamanship,
    this.stamina = 0,
    this.insightTokens = 0,
    this.influenceTokens = 0,
    this.inventory = const [],
    this.isIncapacitated = false,
  });

  CharacterState copyWith({
    int? currentHp,
    int? stamina,
    int? insightTokens,
    int? influenceTokens,
    List<String>? inventory,
    bool? isIncapacitated,
  }) {
    final newHp = (currentHp ?? this.currentHp).clamp(0, maxHp);
    return CharacterState(
      id: id,
      name: name,
      characterClass: characterClass,
      currentHp: newHp,
      maxHp: maxHp,
      might: might,
      agility: agility,
      knowledge: knowledge,
      influence: influence,
      seamanship: seamanship,
      stamina: stamina ?? this.stamina,
      insightTokens: insightTokens ?? this.insightTokens,
      influenceTokens: influenceTokens ?? this.influenceTokens,
      inventory: inventory ?? this.inventory,
      isIncapacitated: newHp == 0,
    );
  }
}
```

---

## 3. LLM Structured Output & JSON Schema Specification

The LLM (Gemini 2.0 Flash / GPT-4o-mini) is invoked with a strict system instruction and structured output schema to prevent free-form hallucinated responses.

### 3.1 LLM System Instruction Prompt

```text
You are SutraDhar, the AI Game Master Companion for a cooperative tabletop RPG set in the 11th-century Chola Empire ("The Lost Ship").
Your primary responsibility is to parse speech transcripts of player dialogue and dice rolls, validate actions against canonical mystery facts, and output a strictly compliant JSON payload.

CANONICAL FACTS (IMMUTABLE TRUTH):
1. The Kadal-Puli merchant vessel was intentionally diverted south after crew members removed an ancient bronze seal from ruins on an uncharted island.
2. The ancient seal was a binding mechanism for the Ashen Guardian (an ancient construct). Removing it awakened the Guardian.
3. The ship escaped under attack, was damaged in a storm, and ran aground along the southern coast.
4. The Ashen Seekers (led by Sembiyan Arul) are mercenaries hunting the artifact for profit; they are not supernatural.
5. The Guardian is NOT an evil deity; it is a mechanism protecting the sanctum from disturbance.

OPERATIONAL RULES:
- PLAYER AGENCY & DIALOGUE: All player decisions are made through spoken table dialogue and roleplay. Never make decisions or choose paths on behalf of the players.
- ZERO DIGITAL DICE: The digital companion never generates random or digital dice rolls. Dice rolls are exclusively physical 2d6 (two six-sided dice) rolled on the table by human players and reported verbally.
- SCORING FORMULA: Total Score = (Die 1 + Die 2) + Attribute Modifier + Situational Bonus. Evaluated against calibrated 2d6 DCs (DC 7 Easy, DC 9 Routine, DC 11 Difficult, DC 13 Very Difficult, DC 15 Exceptional).
- PHYSICAL DICE ONLY FOR RISKY CHECKS: Routine decisions (travel route choices, dialogue, resource trades) are resolved purely through spoken conversation without rolls. Physical 2d6 checks are only required when an action carries risk, danger, or opposition.
- DETERMINISTIC ENFORCEMENT: Never alter character stats arbitrarily; only propose validated state deltas based on reported physical rolls and conversational choices.
- FAIL FORWARD: If a physical check fails, create a narrative complication (e.g., increase Threat, consume Supplies, alter NPC Trust, introduce an obstacle) rather than a dead-end stop.
- Keep narration under 3 sentences: evocative, punchy, and atmospheric for tabletop speech.
- Output ONLY valid JSON adhering to the provided JSON Schema. No markdown wrappers, no introductory chat.
```

### 3.2 Exact JSON Schema (`GameStateDelta`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "GameStateDelta",
  "type": "object",
  "required": [
    "action_type",
    "narration",
    "state_deltas",
    "audio_triggers"
  ],
  "properties": {
    "action_type": {
      "type": "string",
      "enum": ["SKILL_CHECK", "COMBAT_ACTION", "TRAVEL", "INVESTIGATION", "DIALOGUE", "REST"]
    },
    "acting_character_id": {
      "type": "string",
      "enum": ["kavalan", "vetan", "vaniyan", "kalviyalar", "marakkalam", "thoodhuvar", "party", "gm"]
    },
    "check_evaluation": {
      "type": "object",
      "properties": {
        "attribute_used": { "type": "string", "enum": ["might", "agility", "knowledge", "influence", "seamanship"] },
        "die1": { "type": "integer", "minimum": 1, "maximum": 6 },
        "die2": { "type": "integer", "minimum": 1, "maximum": 6 },
        "dice_sum": { "type": "integer", "minimum": 2, "maximum": 12 },
        "attribute_modifier": { "type": "integer" },
        "situational_bonus": { "type": "integer" },
        "total_value": { "type": "integer", "description": "Sum of (die1 + die2) + attribute_modifier + situational_bonus" },
        "target_dc": { "type": "integer" },
        "is_success": { "type": "boolean" },
        "is_critical": { "type": "boolean", "description": "Natural 12 (Double 6s) or Natural 2 (Double 1s)" }
      }
    },
    "state_deltas": {
      "type": "object",
      "required": ["threat_delta", "supplies_delta", "gold_delta"],
      "properties": {
        "target_location": {
          "type": "string",
          "enum": ["thanjavur", "nagapattinam", "coastal_village", "old_road", "open_sea", "island", "ruins"]
        },
        "character_hp_deltas": {
          "type": "object",
          "additionalProperties": { "type": "integer" }
        },
        "threat_delta": { "type": "integer", "minimum": -2, "maximum": 2 },
        "supplies_delta": { "type": "integer", "maximum": 0 },
        "gold_delta": { "type": "integer" },
        "new_clues": {
          "type": "array",
          "items": { "type": "string" }
        },
        "npc_trust_updates": {
          "type": "object",
          "additionalProperties": {
            "type": "string",
            "enum": ["hostile", "wary", "neutral", "helpful", "allied"]
          }
        }
      }
    },
    "narration": {
      "type": "string",
      "description": "2-3 atmospheric sentences for the GM to read to players."
    },
    "gm_secret_note": {
      "type": "string",
      "description": "Private insight or tactical clue visible only in DM Cockpit."
    },
    "audio_triggers": {
      "type": "object",
      "required": ["ambient_track"],
      "properties": {
        "ambient_track": {
          "type": "string",
          "enum": ["silence", "thanjavur_court", "nagapattinam_port", "village_tense", "coastal_night", "sea_voyage", "sea_storm", "island_jungle", "ruins_sanctum", "guardian_combat"]
        },
        "sfx_cue": {
          "type": "string",
          "enum": ["none", "sword_strike", "arrow_release", "dice_roll", "stone_door_open", "thunder_strike", "gold_coins", "wooden_creak", "mystic_drone"]
        }
      }
    }
  }
}
```

---

## 4. Deterministic Rules Engine (`RulesEngine`)

```dart
class RulesEngine {
  /// Validates proposed state deltas and enforces game invariants.
  static GameState applyDelta({
    required GameState currentState,
    required Map<String, CharacterState> characters,
    required GameStateDelta delta,
  }) {
    // 1. Calculate and clamp Threat Level (0 to 6)
    final updatedThreat = (currentState.threatLevel + delta.stateDeltas.threatDelta).clamp(0, 6);

    // 2. Decrement or increment party resources
    final updatedSupplies = (currentState.supplies + delta.stateDeltas.suppliesDelta).clamp(0, 999);
    final updatedGold = (currentState.gold + delta.stateDeltas.goldDelta).clamp(0, 999);

    // 3. Update Clue Registry without duplicates
    final updatedClues = List<String>.from(currentState.discoveredClueIds);
    for (final clue in delta.stateDeltas.newClues) {
      if (!updatedClues.contains(clue)) {
        updatedClues.add(clue);
      }
    }

    // 4. Update NPC Trust mapping
    final updatedTrust = Map<String, NpcTrustLevel>.from(currentState.npcTrust);
    delta.stateDeltas.npcTrustUpdates.forEach((npcId, newTrust) {
      updatedTrust[npcId] = newTrust;
    });

    // 5. Update Location if transition is valid
    CampaignLocation updatedLocation = currentState.currentLocation;
    if (delta.stateDeltas.targetLocation != null) {
      updatedLocation = delta.stateDeltas.targetLocation!;
    }

    return currentState.copyWith(
      turnNumber: currentState.turnNumber + 1,
      currentLocation: updatedLocation,
      threatLevel: updatedThreat,
      supplies: updatedSupplies,
      gold: updatedGold,
      discoveredClueIds: updatedClues,
      npcTrust: updatedTrust,
      activeAmbientTrack: delta.audioTriggers.ambientTrack,
    );
  }
}
```

---

## 5. Dynamic Dual-Channel Audio Architecture (`just_audio`)

The audio engine manages concurrent playback across two dedicated channels without blocking the main UI thread.

```dart
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioManager {
  late final AudioPlayer _ambientPlayerA;
  late final AudioPlayer _ambientPlayerB;
  late final AudioPlayer _sfxPlayer;
  
  bool _isPlayerAActive = true;
  String? _currentAmbientTrack;

  Future<void> initialize() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _ambientPlayerA = AudioPlayer();
    _ambientPlayerB = AudioPlayer();
    _sfxPlayer = AudioPlayer();

    // Set loop modes
    await _ambientPlayerA.setLoopMode(LoopMode.one);
    await _ambientPlayerB.setLoopMode(LoopMode.one);
  }

  /// Cross-fades ambient background music smoothly over [duration]
  Future<void> transitionAmbient(String trackAssetPath, {Duration duration = const Duration(seconds: 3)}) async {
    if (_currentAmbientTrack == trackAssetPath) return;
    _currentAmbientTrack = trackAssetPath;

    final incomingPlayer = _isPlayerAActive ? _ambientPlayerB : _ambientPlayerA;
    final outgoingPlayer = _isPlayerAActive ? _ambientPlayerA : _ambientPlayerB;

    await incomingPlayer.setAsset(trackAssetPath);
    await incomingPlayer.setVolume(0.0);
    incomingPlayer.play();

    // Cross-fade volume loop
    final steps = 30;
    final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);

    for (int i = 1; i <= steps; i++) {
      final fraction = i / steps;
      await incomingPlayer.setVolume(fraction);
      await outgoingPlayer.setVolume(1.0 - fraction);
      await Future.delayed(stepDuration);
    }

    await outgoingPlayer.stop();
    _isPlayerAActive = !_isPlayerAActive;
  }

  /// Low-latency one-shot SFX playback on Channel 2
  Future<void> playSfx(String sfxAssetPath) async {
    if (sfxAssetPath == 'none') return;
    await _sfxPlayer.setAsset(sfxAssetPath);
    await _sfxPlayer.setVolume(1.0);
    await _sfxPlayer.seek(Duration.zero);
    _sfxPlayer.play();
  }

  Future<void> dispose() async {
    await _ambientPlayerA.dispose();
    await _ambientPlayerB.dispose();
    await _sfxPlayer.dispose();
  }
}
```

---

## 6. Local Database & Persistence Schema (Drift ORM)

```dart
import 'package:drift/drift.dart';

class CampaignsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastPlayedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EventLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get campaignId => text().references(CampaignsTable, #id)();
  IntColumn get turnNumber => integer()();
  TextColumn get rawTranscript => text()();
  TextColumn get parsedJsonDelta => text()();
  TextColumn get narration => text()();
  DateTimeColumn get timestamp => dateTime()();
}

class CluesDiscoveredTable extends Table {
  TextColumn get clueId => text()();
  TextColumn get campaignId => text().references(CampaignsTable, #id)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get turnDiscovered => integer()();

  @override
  Set<Column> get primaryKey => {clueId, campaignId};
}
```

---

## 7. Dual-Screen UI Presentation Specifications

### 7.1 DM Cockpit (`DmCockpitScreen`)
- **PTT Button**: Prominent circular floating action button with visual microphone waveform feedback.
- **Action Verification Queue**: Renders `ActionQueueCard` containing:
  - Color-coded action banner (`COMBAT: RED`, `CHECK: AMBER`, `TRAVEL: BLUE`).
  - Extracted dice roll vs DC badge (`12 vs DC 11: SUCCESS - [5 + 4] + Mod: 3`).
  - Proposed numerical state deltas (`Threat +1`, `Supplies -1`).
  - **[Accept]**, **[Edit]**, and **[Reject]** action buttons.
- **Secret Lore Accordion**: Reveals private NPC motivations and canonical insights invisible to players.

### 7.2 Tabletop View (`TabletopScreen`)
- **Canvas Engine**: Flutter `InteractiveViewer` with smooth pan and pinch-to-zoom over high-res 4K parchment map artwork.
- **Dynamic Fog of War**: Custom painter masking unvisited nodes with hand-drawn cloud texture; dissolves upon entering a new location.
- **Party HUD**: Minimalist bottom overlay displaying:
  - Active character tokens with live animated HP bars.
  - Threat Clock circular dial (divided into 6 segments, glowing red as Threat escalates).
  - Supplies sack icon and Gold counter.
