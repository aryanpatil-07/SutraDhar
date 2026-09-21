enum CharacterCondition {
  healthy,
  injured,
  incapacitated,
}

class ActiveCharacter {
  final String id;
  final String name;
  final String role;
  final String playerName;
  final int currentHp;
  final int maxHp;

  // 2d6 Attribute Modifiers
  final int might;
  final int agility;
  final int knowledge;
  final int influence;
  final int seamanship;

  // Resource Pools
  final int stamina;
  final int insightTokens;
  final int influenceTokens;

  final CharacterCondition condition;
  final List<String> inventory;

  const ActiveCharacter({
    required this.id,
    required this.name,
    required this.role,
    this.playerName = '',
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
    this.condition = CharacterCondition.healthy,
    this.inventory = const [],
  });

  bool get isIncapacitated => currentHp <= 0;

  ActiveCharacter copyWith({
    String? playerName,
    int? currentHp,
    int? stamina,
    int? insightTokens,
    int? influenceTokens,
    CharacterCondition? condition,
    List<String>? inventory,
  }) {
    final updatedHp = (currentHp ?? this.currentHp).clamp(0, maxHp);
    final updatedCondition = updatedHp == 0
        ? CharacterCondition.incapacitated
        : (updatedHp < maxHp * 0.5 ? CharacterCondition.injured : CharacterCondition.healthy);

    return ActiveCharacter(
      id: id,
      name: name,
      role: role,
      playerName: playerName ?? this.playerName,
      currentHp: updatedHp,
      maxHp: maxHp,
      might: might,
      agility: agility,
      knowledge: knowledge,
      influence: influence,
      seamanship: seamanship,
      stamina: (stamina ?? this.stamina).clamp(0, 99),
      insightTokens: (insightTokens ?? this.insightTokens).clamp(0, 99),
      influenceTokens: (influenceTokens ?? this.influenceTokens).clamp(0, 99),
      condition: updatedCondition,
      inventory: inventory ?? this.inventory,
    );
  }

  ActiveCharacter takeDamage(int amount) {
    return copyWith(currentHp: currentHp - amount);
  }

  ActiveCharacter heal(int amount) {
    return copyWith(currentHp: currentHp + amount);
  }
}
