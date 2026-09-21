import 'game_state_model.dart';
import '../../../../core/constants/campaign_constants.dart';

class NpcDossier {
  final String id;
  final String name;
  final String title;
  final CampaignLocation location;
  final NpcTrustLevel startingTrust;
  final String desire;
  final String fear;
  final String secretKnowledge;
  final String dialogueVoice;

  const NpcDossier({
    required this.id,
    required this.name,
    required this.title,
    required this.location,
    required this.startingTrust,
    required this.desire,
    required this.fear,
    required this.secretKnowledge,
    required this.dialogueVoice,
  });

  static const List<NpcDossier> allNpcs = [
    NpcDossier(
      id: 'ananthan',
      name: 'Ananthan',
      title: 'Harbor Registry Clerk',
      location: CampaignLocation.nagapattinam,
      startingTrust: NpcTrustLevel.wary,
      desire: 'To protect himself and his family from mercenary vengeance.',
      fear: 'Being executed for tampering with imperial Chola court shipping records.',
      secretKnowledge:
          'Armed mercenaries forced him to erase the Kadal-Puli\'s southward route to the coastal village.',
      dialogueVoice: 'Nervous, rapid, apologetic whispers, repeatedly looking over his shoulder.',
    ),
    NpcDossier(
      id: 'muthu',
      name: 'Muthu',
      title: 'Elder Fisherman',
      location: CampaignLocation.coastalVillage,
      startingTrust: NpcTrustLevel.wary,
      desire: 'To repair his village\'s smashed catamarans and protect his fishermen.',
      fear: 'Outsiders bringing war and ruin to his peaceful coastal inlet.',
      secretKnowledge:
          'Saw the damaged Kadal-Puli sailing south with an eerie bronze glow; injured sailors fled along the Old Road.',
      dialogueVoice: 'Gruff, weathered Tamil filled with ocean metaphors and cautious reverence.',
    ),
    NpcDossier(
      id: 'sembiyan',
      name: 'Sembiyan Arul',
      title: 'Leader of the Ashen Seekers',
      location: CampaignLocation.oldRoad,
      startingTrust: NpcTrustLevel.neutral,
      desire: 'To recover the ancient bronze artifact and sell it for personal fortune.',
      fear: 'Pointless death, losing his hired men, or getting entangled with court authorities.',
      secretKnowledge:
          'Does not know the true supernatural nature of the seal; believes it is pure gold and bronze treasure.',
      dialogueVoice: 'Calculating, calm, measured cadence; respects strength and clever diplomacy over violence.',
    ),
    NpcDossier(
      id: 'guardian',
      name: 'The Ashen Guardian',
      title: 'Sanctum Sentinel Construct',
      location: CampaignLocation.ruins,
      startingTrust: NpcTrustLevel.neutral,
      desire: 'To protect the inner sacred sanctum and keep the Bronze Seal mounted in its pedestal.',
      fear: 'Defilement of the sacred mechanism.',
      secretKnowledge:
          'Is not an evil demon; attacks only when the chamber is disturbed or the seal is taken away.',
      dialogueVoice: 'Deep mechanical grinding of basalt stones, ancient resonant drones.',
    ),
  ];
}
