import 'dart:convert';

enum CharacterArchetype {
  kavalan,
  vetan,
  vaniyan,
  kalviyalar,
  marakkalam,
  thoodhuvar,
}

enum GameMode {
  assistedGm,
  autonomousCoDm,
}

enum SessionPacing {
  fullCampaign,
  quickDemo,
}

enum Act1DepartureChoice {
  extraSupplies,
  royalSeal,
  swiftDeparture,
  crewRecords,
}

class CharacterProfile {
  final CharacterArchetype archetype;
  final String id;
  final String name;
  final String role;
  final String epithet;
  final int hp;
  final int might;
  final int agility;
  final int knowledge;
  final int influence;
  final int seamanship;
  final List<String> abilities;
  final List<String> equipment;

  const CharacterProfile({
    required this.archetype,
    required this.id,
    required this.name,
    required this.role,
    required this.epithet,
    required this.hp,
    required this.might,
    required this.agility,
    required this.knowledge,
    required this.influence,
    required this.seamanship,
    required this.abilities,
    required this.equipment,
  });

  static const List<CharacterProfile> allArchetypes = [
    CharacterProfile(
      archetype: CharacterArchetype.kavalan,
      id: 'kavalan',
      name: 'Kavalan',
      role: 'Guardian / Warrior',
      epithet: 'The Bronze Shield of the Coast',
      hp: 14,
      might: 5,
      agility: 3,
      knowledge: 1,
      influence: 2,
      seamanship: 2,
      abilities: [
        'Guard: Intercept an attack targeting an adjacent ally once per round.',
        'Powerful Strike: Spend 1 Stamina to add +3 on any Might roll.',
      ],
      equipment: ['Chola Bronze Spear (1d6+1)', 'Heavy Teak Shield (+2 Def)', '2 Stamina'],
    ),
    CharacterProfile(
      archetype: CharacterArchetype.vetan,
      id: 'vetan',
      name: 'Vēṭan',
      role: 'Scout / Hunter',
      epithet: 'The Eye of the Wild Scrub',
      hp: 11,
      might: 3,
      agility: 5,
      knowledge: 2,
      influence: 2,
      seamanship: 3,
      abilities: [
        'Tracker: Reveal an extra critical detail on any successful tracking check.',
        'Ambush: Deal +3 attack roll and +1d4 damage when surprising an enemy.',
      ],
      equipment: ['Composite Bow (1d6)', 'Hunting Knife (1d4)', 'Coiled Rope', '2 Stamina'],
    ),
    CharacterProfile(
      archetype: CharacterArchetype.vaniyan,
      id: 'vaniyan',
      name: 'Vāṇiyan',
      role: 'Merchant / Guild Factor',
      epithet: 'Lord of the Five Hundred Guilds',
      hp: 10,
      might: 2,
      agility: 2,
      knowledge: 3,
      influence: 5,
      seamanship: 4,
      abilities: [
        'Bargain: Reduce reasonable purchase costs by 1 Gold per settlement.',
        'Connections: Declare a plausible guild contact in any major port.',
      ],
      equipment: ['Merchant Ledger', 'Trade Spices', '3 Stamped Gold Kasu'],
    ),
    CharacterProfile(
      archetype: CharacterArchetype.kalviyalar,
      id: 'kalviyalar',
      name: 'Kalviyalār',
      role: 'Scholar / Epigraphist',
      epithet: 'Decipherer of the Stone Decrees',
      hp: 9,
      might: 1,
      agility: 2,
      knowledge: 5,
      influence: 4,
      seamanship: 2,
      abilities: [
        'Read the Past: Gain additional historical context from inscriptions.',
        'Insight: Ask the AI/GM for the most vital overlooked clue once per site.',
      ],
      equipment: ['Palm-Leaf Folio', 'Brass Lamp', '2 Insight Tokens'],
    ),
    CharacterProfile(
      archetype: CharacterArchetype.marakkalam,
      id: 'marakkalam',
      name: 'Marakkalam Navigator',
      role: 'Sailor / Helmsman',
      epithet: 'Master of the Monsoon Winds',
      hp: 11,
      might: 2,
      agility: 3,
      knowledge: 3,
      influence: 2,
      seamanship: 5,
      abilities: [
        'Read the Sea: Identify incoming storm squalls and dangerous shoals.',
        'Master Navigator: Unlock alternative oceanic routes to bypass hazards.',
      ],
      equipment: ['Sun-Stone Compass', 'Rigging Knife', '2 Extra Supplies'],
    ),
    CharacterProfile(
      archetype: CharacterArchetype.thoodhuvar,
      id: 'thoodhuvar',
      name: 'Thoodhuvar',
      role: 'Envoy / Diplomat',
      epithet: 'Voice of the Chola Emperor',
      hp: 10,
      might: 2,
      agility: 2,
      knowledge: 4,
      influence: 5,
      seamanship: 2,
      abilities: [
        'Diplomatic Immunity: Prevent an encounter from turning hostile.',
        'Persuade: Spend 1 Influence Token to reroll a failed Influence check.',
      ],
      equipment: ['Imperial Royal Seal', 'Silk Shawl', '2 Influence Tokens'],
    ),
  ];
}

class SessionConfiguration {
  final List<String> selectedCharacterIds;
  final Map<String, String> playerNames;
  final GameMode gameMode;
  final SessionPacing sessionPacing;
  final Act1DepartureChoice departureChoice;
  final DateTime createdAt;

  const SessionConfiguration({
    required this.selectedCharacterIds,
    required this.playerNames,
    this.gameMode = GameMode.assistedGm,
    this.sessionPacing = SessionPacing.fullCampaign,
    this.departureChoice = Act1DepartureChoice.swiftDeparture,
    required this.createdAt,
  });

  bool get isValid => selectedCharacterIds.length == 4;

  SessionConfiguration copyWith({
    List<String>? selectedCharacterIds,
    Map<String, String>? playerNames,
    GameMode? gameMode,
    SessionPacing? sessionPacing,
    Act1DepartureChoice? departureChoice,
  }) {
    return SessionConfiguration(
      selectedCharacterIds: selectedCharacterIds ?? this.selectedCharacterIds,
      playerNames: playerNames ?? this.playerNames,
      gameMode: gameMode ?? this.gameMode,
      sessionPacing: sessionPacing ?? this.sessionPacing,
      departureChoice: departureChoice ?? this.departureChoice,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedCharacterIds': selectedCharacterIds,
      'playerNames': playerNames,
      'gameMode': gameMode.name,
      'sessionPacing': sessionPacing.name,
      'departureChoice': departureChoice.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SessionConfiguration.fromMap(Map<String, dynamic> map) {
    return SessionConfiguration(
      selectedCharacterIds: List<String>.from(map['selectedCharacterIds'] ?? []),
      playerNames: Map<String, String>.from(map['playerNames'] ?? {}),
      gameMode: GameMode.values.firstWhere(
        (e) => e.name == map['gameMode'],
        orElse: () => GameMode.assistedGm,
      ),
      sessionPacing: SessionPacing.values.firstWhere(
        (e) => e.name == map['sessionPacing'],
        orElse: () => SessionPacing.fullCampaign,
      ),
      departureChoice: Act1DepartureChoice.values.firstWhere(
        (e) => e.name == map['departureChoice'],
        orElse: () => Act1DepartureChoice.swiftDeparture,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionConfiguration.fromJson(String source) =>
      SessionConfiguration.fromMap(json.decode(source));
}
