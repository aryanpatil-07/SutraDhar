import '../../../../core/constants/campaign_constants.dart';

enum NpcTrustLevel {
  hostile,
  wary,
  neutral,
  helpful,
  allied,
}

class ActiveGameState {
  final CampaignLocation location;
  final int turnNumber;
  final int threatLevel; // 0 to 6
  final int supplies;
  final int gold;
  final List<String> discoveredClueIds;
  final Map<String, NpcTrustLevel> npcTrust;
  final bool isCombatActive;
  final List<String> combatInitiativeOrder;
  final String activeAmbientTrack;

  const ActiveGameState({
    required this.location,
    this.turnNumber = 1,
    this.threatLevel = 0,
    this.supplies = 8,
    this.gold = 3,
    this.discoveredClueIds = const [],
    this.npcTrust = const {
      'ananthan': NpcTrustLevel.wary,
      'muthu': NpcTrustLevel.wary,
      'sembiyan': NpcTrustLevel.neutral,
      'guardian': NpcTrustLevel.neutral,
    },
    this.isCombatActive = false,
    this.combatInitiativeOrder = const [],
    this.activeAmbientTrack = 'thanjavur_court',
  });

  ActiveGameState copyWith({
    CampaignLocation? location,
    int? turnNumber,
    int? threatLevel,
    int? supplies,
    int? gold,
    List<String>? discoveredClueIds,
    Map<String, NpcTrustLevel>? npcTrust,
    bool? isCombatActive,
    List<String>? combatInitiativeOrder,
    String? activeAmbientTrack,
  }) {
    return ActiveGameState(
      location: location ?? this.location,
      turnNumber: turnNumber ?? this.turnNumber,
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
