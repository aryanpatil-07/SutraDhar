import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../campaign_rules/domain/models/character_model.dart';
import '../../campaign_rules/domain/models/game_state_model.dart';
import '../../campaign_rules/domain/rules_engine.dart';
import '../../../core/constants/campaign_constants.dart';

class AiRepository {
  final String? apiKey;

  AiRepository({this.apiKey});

  /// Main entry point: Parses player dialogue and reported physical 2d6 rolls into a ProposedActionDelta.
  Future<ProposedActionDelta> parseSpeechToStateDelta({
    required String speechTranscript,
    required ActiveGameState gameState,
    required Map<String, ActiveCharacter> characters,
  }) async {
    // If a live API key is present, attempt live LLM structured extraction
    if (apiKey != null && apiKey!.isNotEmpty) {
      try {
        final result = await _callGeminiApi(speechTranscript, gameState, characters);
        if (result != null) return result;
      } catch (_) {
        // Fall back gracefully to the deterministic offline heuristic parser
      }
    }

    // Deterministic Heuristic Parser (100% Offline Resilience)
    return _parseOfflineHeuristic(speechTranscript, gameState, characters);
  }

  Future<ProposedActionDelta?> _callGeminiApi(
    String transcript,
    ActiveGameState gameState,
    Map<String, ActiveCharacter> characters,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final systemInstruction = '''
You are SutraDhar, the AI Game Master Companion for a cooperative tabletop RPG in 11th-century Chola Empire ("The Lost Ship").
Parse speech transcripts of player dialogue and physical 2d6 dice rolls.
Current location: ${gameState.location.name}. Threat: ${gameState.threatLevel}. Supplies: ${gameState.supplies}. Gold: ${gameState.gold}.
Calculate score as (die1 + die2) + attribute_modifier + situational_bonus against calibrated DCs (7 Easy, 9 Routine, 11 Difficult, 13 Very Difficult, 15 Exceptional).
Return ONLY a valid JSON object matching:
{
  "action_type": "SKILL_CHECK" | "COMBAT_ACTION" | "TRAVEL" | "INVESTIGATION" | "DIALOGUE" | "REST",
  "acting_character_id": "kavalan" | "vetan" | "vaniyan" | "kalviyalar" | "marakkalam" | "thoodhuvar" | "party",
  "die1": 1-6,
  "die2": 1-6,
  "attribute_used": "might" | "agility" | "knowledge" | "influence" | "seamanship",
  "target_dc": 7-15,
  "threat_delta": integer (-2 to 2),
  "supplies_delta": integer,
  "gold_delta": integer,
  "character_hp_deltas": { "character_id": integer },
  "new_clues": [string],
  "narration": "2-3 atmospheric sentences",
  "gm_secret_note": "private note for GM"
}
''';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'contents': [
          {
            'parts': [
              {'text': '$systemInstruction\n\nPlayer Speech Transcript:\n"$transcript"'}
            ]
          }
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'temperature': 0.2,
        },
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final rawText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      final parsed = json.decode(rawText);

      return _mapJsonToDelta(parsed, characters);
    }
    return null;
  }

  ProposedActionDelta _mapJsonToDelta(
    Map<String, dynamic> json,
    Map<String, ActiveCharacter> characters,
  ) {
    final actionTypeStr = json['action_type'] as String? ?? 'SKILL_CHECK';
    final actionType = ActionType.values.firstWhere(
      (a) => a.name.toLowerCase() == actionTypeStr.toLowerCase().replaceAll('_', ''),
      orElse: () => ActionType.skillCheck,
    );

    final charId = json['acting_character_id'] as String? ?? 'party';
    CheckEvaluation? evaluation;

    if (json.containsKey('die1') && json.containsKey('die2')) {
      final d1 = (json['die1'] as num).toInt();
      final d2 = (json['die2'] as num).toInt();
      final attr = json['attribute_used'] as String? ?? 'might';
      final dc = (json['target_dc'] as num?)?.toInt() ?? StandardDc2d6.routine;

      int modifier = 2;
      if (characters.containsKey(charId)) {
        final c = characters[charId]!;
        switch (attr) {
          case 'might':
            modifier = c.might;
            break;
          case 'agility':
            modifier = c.agility;
            break;
          case 'knowledge':
            modifier = c.knowledge;
            break;
          case 'influence':
            modifier = c.influence;
            break;
          case 'seamanship':
            modifier = c.seamanship;
            break;
        }
      }

      evaluation = RulesEngine.evaluate2d6(
        attribute: attr,
        die1: d1,
        die2: d2,
        modifier: modifier,
        targetDc: dc,
      );
    }

    final hpDeltas = <String, int>{};
    if (json['character_hp_deltas'] is Map) {
      (json['character_hp_deltas'] as Map).forEach((k, v) {
        hpDeltas[k.toString()] = (v as num).toInt();
      });
    }

    return ProposedActionDelta(
      actionType: actionType,
      actingCharacterId: charId,
      checkEvaluation: evaluation,
      threatDelta: (json['threat_delta'] as num?)?.toInt() ?? 0,
      suppliesDelta: (json['supplies_delta'] as num?)?.toInt() ?? 0,
      goldDelta: (json['gold_delta'] as num?)?.toInt() ?? 0,
      newClues: List<String>.from(json['new_clues'] ?? []),
      narration: json['narration'] as String? ?? 'The action resolves.',
      gmSecretNote: json['gm_secret_note'] as String? ?? '',
    );
  }

  /// Deterministic Heuristic Parser for offline testing and speech evaluation
  ProposedActionDelta _parseOfflineHeuristic(
    String transcript,
    ActiveGameState gameState,
    Map<String, ActiveCharacter> characters,
  ) {
    final lower = transcript.toLowerCase();

    // 1. Identify acting character
    String charId = 'kavalan';
    for (final key in characters.keys) {
      if (lower.contains(key) || lower.contains(characters[key]!.name.toLowerCase())) {
        charId = key;
        break;
      }
    }
    final char = characters[charId] ?? characters.values.first;

    // 2. Identify 2d6 Dice numbers in speech
    int die1 = 4;
    int die2 = 3;
    final diceRegex = RegExp(r'(\d)\s*(?:and|\+|,)\s*(\d)');
    final singleRegex = RegExp(r'(?:rolled|got|roll|score)\s*(?:a|an)?\s*(\d+)');

    final matchDice = diceRegex.firstMatch(lower);
    if (matchDice != null) {
      die1 = (int.tryParse(matchDice.group(1)!) ?? 4).clamp(1, 6);
      die2 = (int.tryParse(matchDice.group(2)!) ?? 3).clamp(1, 6);
    } else {
      final matchSingle = singleRegex.firstMatch(lower);
      if (matchSingle != null) {
        final total = int.tryParse(matchSingle.group(1)!) ?? 7;
        die1 = (total ~/ 2).clamp(1, 6);
        die2 = (total - die1).clamp(1, 6);
      }
    }

    // 3. Identify attribute and target DC
    String attribute = 'might';
    int modifier = char.might;
    int targetDc = StandardDc2d6.routine; // DC 9

    if (lower.contains('agil') || lower.contains('sneak') || lower.contains('bow') || lower.contains('dodge')) {
      attribute = 'agility';
      modifier = char.agility;
    } else if (lower.contains('know') || lower.contains('inscript') || lower.contains('read') || lower.contains('history')) {
      attribute = 'knowledge';
      modifier = char.knowledge;
      targetDc = StandardDc2d6.difficult; // DC 11
    } else if (lower.contains('influ') || lower.contains('convince') || lower.contains('bribe') || lower.contains('talk')) {
      attribute = 'influence';
      modifier = char.influence;
    } else if (lower.contains('sea') || lower.contains('sail') || lower.contains('storm') || lower.contains('boat')) {
      attribute = 'seamanship';
      modifier = char.seamanship;
    }

    final evaluation = RulesEngine.evaluate2d6(
      attribute: attribute,
      die1: die1,
      die2: die2,
      modifier: modifier,
      targetDc: targetDc,
    );

    // 4. Derive consequences based on success/failure
    ActionType actionType = ActionType.skillCheck;
    int threatDelta = 0;
    int suppliesDelta = 0;
    final hpDeltas = <String, int>{};
    final newClues = <String>[];
    String narration = '';
    String gmSecretNote = '';

    if (lower.contains('attack') || lower.contains('strike') || lower.contains('spear') || lower.contains('fight')) {
      actionType = ActionType.combatAction;
      if (evaluation.isSuccess) {
        narration =
            '${char.name}\'s strike hits true! Bronze meets iron with a resounding clash, driving the hostile fighters back.';
        gmSecretNote = 'The enemy is shaken. One more successful blow or an Influence check will cause them to yield.';
      } else {
        hpDeltas[char.id] = -2;
        threatDelta = 1;
        narration =
            '${char.name} lunges forward, but the opponent parries sharply, delivering a painful counter-blow (-2 HP). Threat rises!';
        gmSecretNote = 'Remind the Guardian of the Guard ability to protect adjacent companions.';
      }
    } else if (lower.contains('travel') || lower.contains('head to') || lower.contains('sail')) {
      actionType = ActionType.travel;
      suppliesDelta = -1;
      narration = 'The party journeys onward across the Coromandel coast, consuming travel provisions (-1 Supply).';
      gmSecretNote = 'Describe the changing terrain and ambient smells as they approach the new region.';
    } else {
      actionType = ActionType.investigation;
      if (evaluation.isSuccess) {
        newClues.add('${gameState.location.name}_clue_${gameState.discoveredClueIds.length + 1}');
        narration =
            '${char.name} carefully investigates the scene. A vital hidden detail comes to light beneath the sand and stone.';
        gmSecretNote = 'Award the relevant Clue Card from the box to the player.';
      } else {
        threatDelta = 1;
        narration =
            'The search takes longer than anticipated. Distant horns sound in the scrubland as Threat rises (+1 Threat).';
        gmSecretNote = 'A clue can still be discovered, but enemies are now aware of the party\'s presence.';
      }
    }

    return ProposedActionDelta(
      actionType: actionType,
      actingCharacterId: char.id,
      checkEvaluation: evaluation,
      characterHpDeltas: hpDeltas,
      threatDelta: threatDelta,
      suppliesDelta: suppliesDelta,
      newClues: newClues,
      narration: narration,
      gmSecretNote: gmSecretNote,
    );
  }
}
