import '../../campaign_rules/domain/models/game_state_model.dart';
import '../../campaign_rules/domain/models/npc_model.dart';
import '../../../core/constants/campaign_constants.dart';

class StorylineGuidance {
  final String chapterTitle;
  final String currentGoal;
  final String atmosphericNarrationHint;
  final List<String> gmDirectives;
  final List<String> secretWhispers;
  final List<String> unrevealedClues;
  final String? threatWarning;

  const StorylineGuidance({
    required this.chapterTitle,
    required this.currentGoal,
    required this.atmosphericNarrationHint,
    required this.gmDirectives,
    required this.secretWhispers,
    required this.unrevealedClues,
    this.threatWarning,
  });
}

class StorylineGuidanceEngine {
  static StorylineGuidance generateGuidance({
    required ActiveGameState gameState,
  }) {
    final meta = LocationMetadata.all[gameState.location]!;
    final threat = gameState.threatLevel;
    final clues = gameState.discoveredClueIds;

    String? threatWarning;
    if (threat >= 4) {
      threatWarning =
          'CRITICAL THREAT ($threat/6): Mercenaries are actively ambushing the party or ancient temple stones are crumbling!';
    } else if (threat >= 2) {
      threatWarning =
          'ELEVATED THREAT ($threat/6): NPCs are becoming wary of being seen talking to the players.';
    }

    switch (gameState.location) {
      case CampaignLocation.thanjavur:
        return StorylineGuidance(
          chapterTitle: 'Act I: The Thanjavur Briefing',
          currentGoal: 'Receive the imperial commission and depart toward Nagapattinam.',
          atmosphericNarrationHint:
              'Describe the heavy royal security in the court. The official unrolls the coastal map with urgency.',
          gmDirectives: [
            'Remind players that their assignment is to recover the sealed royal cylinder, not fight wars.',
            'Encourage the Scholar to inspect the missing ship\'s cargo manifest.',
            'If players argue over supplies, prompt them: "Does speed matter more than rations?"',
          ],
          secretWhispers: [
            'The royal cylinder contains classified orders regarding ancient island coordinates.',
            'The court suspects someone inside the port authority helped divert the ship.',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.nagapattinam:
        return StorylineGuidance(
          chapterTitle: 'Act II / Chapter 2: Nagapattinam Harbor Sandbox',
          currentGoal: 'Find proof of where the Kadal-Puli sailed after leaving the port.',
          atmosphericNarrationHint:
              'Highlight the sensory overload: fish markets, Arabic traders, foreign sails, and nervous glances.',
          gmDirectives: [
            'Direct attention to the 4 sources: Registry Clerk Ananthan, Fisherman Muthu, the Berth, or Customs.',
            'If players are stuck, have a frightened dock worker deliberately avoid eye contact.',
            'Remember the 3-Clue Rule: either the altered records, Muthu\'s testimony, or the bronze fragment unlocks the Coastal Village.',
          ],
          secretWhispers: [
            'Ananthan knows the ship sailed south, but won\'t speak unless bribed with 1 Gold or assured safety.',
            'Muthu saw the ship glowing with eerie bronze light three nights ago.',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.coastalVillage:
        return StorylineGuidance(
          chapterTitle: 'Act II / Chapter 3: The Coastal Village',
          currentGoal: 'Investigate the damaged catamarans and confront the Ashen Seekers.',
          atmosphericNarrationHint:
              'A tense silence hangs over stilted wooden huts. Villagers huddle together while armed mercenaries intimidate them.',
          gmDirectives: [
            'Present the moral dilemma: helping the villagers earns their trust but burns time and supplies.',
            'Allow the Envoy (Thoodhuvar) or Merchant (Vāṇiyan) to negotiate before swords are drawn.',
            'If combat starts, keep it brief—the mercenaries will retreat toward the Old Road once injured.',
          ],
          secretWhispers: [
            'Sembiyan Arul is not here yet; his lieutenant is searching for injured Chola sailors who washed ashore.',
            'Elder Muthu\'s family will reveal the inland trail if the mercenaries are driven away.',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.oldRoad:
        return StorylineGuidance(
          chapterTitle: 'Act III / Chapter 4 & 5: The Old Inland Road',
          currentGoal: 'Follow the dual tracks to the abandoned camp and locate the wreck.',
          atmosphericNarrationHint:
              'Thorny coastal scrub closes in. The Scout (Vēṭan) spots two distinct trails in the muddy ground.',
          gmDirectives: [
            'Highlight Vēṭan\'s tracking ability: distinguish fleeing sailors from armed pursuers.',
            'Introduce Sembiyan Arul: he is pragmatic and willing to strike a deal rather than throw away lives.',
            'Reward discovery of the Captain\'s Journal fragment with the revelation that an island was involved.',
          ],
          secretWhispers: [
            'Sembiyan Arul does not know the artifact is an automaton seal; he thinks it is pure gold.',
            'If players offer a truce, Sembiyan agrees to let them inspect the ship wreck peacefully.',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.openSea:
        return StorylineGuidance(
          chapterTitle: 'Act IV / Chapter 7: Crossing the Bay of Bengal',
          currentGoal: 'Navigate the monsoon squall to reach the uncharted volcanic island.',
          atmosphericNarrationHint:
              'Choppy grey waves crash over the bow. The Navigator (Marakkalam) reads the shifting clouds.',
          gmDirectives: [
            'Offer the 3 route choices: Safe Coastal Channel (2 Supplies), Fast Monsoon Channel (DC 11 Seamanship), or Hidden Current.',
            'Introduce the survivor clinging to timber: rescuing him costs 1 Supply but gives the vital warning.',
            'If a check fails, apply hull damage or increase Threat rather than sinking the vessel.',
          ],
          secretWhispers: [
            'The floating sailor will reveal the most critical clue: "The guardian only attacked when we pried off the seal!"',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.island:
        return StorylineGuidance(
          chapterTitle: 'Act V / Chapter 8: The Uncharted Island',
          currentGoal: 'Ascend the monolithic stone steps through the jungle to the ruins.',
          atmosphericNarrationHint:
              'Unsettling, absolute quiet. Black volcanic reefs ring the shore. Giant banyan roots swallow ancient stone steps.',
          gmDirectives: [
            'Have the Scout detect tripwires left by the panicked crew.',
            'Describe the ancient Dravidian stonework growing older and grander as they climb.',
            'Build atmospheric tension as ambient sound transitions to low subterranean drones.',
          ],
          secretWhispers: [
            'The Ashen Guardian has already detected movement on the island; every loud failure ticks Threat +1.',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );

      case CampaignLocation.ruins:
        return StorylineGuidance(
          chapterTitle: 'Climax / Chapters 9–12: The Sacred Ruins (Ashen Sanctum)',
          currentGoal: 'Decide the fate of the Bronze Seal and survive the Ashen Guardian.',
          atmosphericNarrationHint:
              'A subterranean obsidian cathedral. The empty basalt pedestal sits in silence until heavy stone footsteps grind behind the altar.',
          gmDirectives: [
            'Emphasize that the Guardian is a mechanism bound to protect the sanctum, not an evil deity.',
            'Allow both puzzle solutions (re-mounting the Bronze Seal) and combat tactics.',
            'When Sembiyan arrives, let the players decide whether to convince him, trick him, or fight.',
            'Guide the group toward one of the 5 canonical endings (Protector, Expedient, Bargain, Costly Victory, Collapse).',
          ],
          secretWhispers: [
            'Re-inserting the seal requires DC 11 Might to distract the construct and DC 10 Agility to lock it in place.',
            'Surrendering the seal to Sembiyan causes the entire sanctum to collapse!',
          ],
          unrevealedClues: meta.availableClues.where((c) => !clues.contains(c)).toList(),
          threatWarning: threatWarning,
        );
    }
  }
}
