enum CampaignLocation {
  thanjavur,
  nagapattinam,
  coastalVillage,
  oldRoad,
  openSea,
  island,
  ruins,
}

class LocationMetadata {
  final CampaignLocation location;
  final String title;
  final String regionSubtitle;
  final String sensoryDescription;
  final List<String> primaryEncounters;
  final List<String> availableClues;

  const LocationMetadata({
    required this.location,
    required this.title,
    required this.regionSubtitle,
    required this.sensoryDescription,
    required this.primaryEncounters,
    required this.availableClues,
  });

  static const Map<CampaignLocation, LocationMetadata> all = {
    CampaignLocation.thanjavur: LocationMetadata(
      location: CampaignLocation.thanjavur,
      title: 'Thanjavur',
      regionSubtitle: 'Imperial Capital & Administrative Court',
      sensoryDescription:
          'Distant temple chants echo over bureaucratic stone halls. Royal scribes record grain manifests on palm-leaf folios under the shadow of the Great Vimana.',
      primaryEncounters: ['Imperial Briefing', 'Court Scribe Inquiry', 'Route Preparation'],
      availableClues: ['royal_orders', 'altered_route_note'],
    ),
    CampaignLocation.nagapattinam: LocationMetadata(
      location: CampaignLocation.nagapattinam,
      title: 'Nagapattinam',
      regionSubtitle: 'Principal Imperial Oceanic Port',
      sensoryDescription:
          'The sharp scent of brine and roasted spices fills the air. Foreign dhows, Chinese junks, and Chola marakkalam vessels jostle in the crowded river mouth.',
      primaryEncounters: ['Dock Worker Ananthan', 'Fisherman Muthu', 'Warehouse Search'],
      availableClues: ['altered_manifest', 'bronze_fragment', 'night_lights_testimony'],
    ),
    CampaignLocation.coastalVillage: LocationMetadata(
      location: CampaignLocation.coastalVillage,
      title: 'Coastal Village',
      regionSubtitle: 'Fishing Settlement & Southern Inlet',
      sensoryDescription:
          'Stilted huts sit quiet under palm trees. Smashed catamarans litter the wet sand, and five armed mercenaries stand watch with drawn weapons.',
      primaryEncounters: ['Ashen Seekers Stand-off', 'Villager Rescue', 'Catamaran Repair'],
      availableClues: ['seeker_orders', 'inland_trail_discovery'],
    ),
    CampaignLocation.oldRoad: LocationMetadata(
      location: CampaignLocation.oldRoad,
      title: 'The Old Road',
      regionSubtitle: 'Dense Thorny Scrubland & Inland Trail',
      sensoryDescription:
          'Overgrown stone pavers wind through dense coastal scrub. Heavy tracks in the mud reveal fleeing sailors pursued by armed mercenaries.',
      primaryEncounters: ['Dual Track Investigation', 'Abandoned Campsite', 'Sembiyan Ambush'],
      availableClues: ['captains_journal_scrap', 'bloodstained_sailcloth'],
    ),
    CampaignLocation.openSea: LocationMetadata(
      location: CampaignLocation.openSea,
      title: 'Open Sea',
      regionSubtitle: 'Bay of Bengal Ocean Passage',
      sensoryDescription:
          'Choppy grey-blue swells toss the hull. The northeast monsoon wind roars through the rigging as thunder rumbles over the eastern horizon.',
      primaryEncounters: ['Monsoon Squall', 'Floating Wreckage', 'Survivor in Water'],
      availableClues: ['floating_survivor_warning', 'shipwreck_direction'],
    ),
    CampaignLocation.island: LocationMetadata(
      location: CampaignLocation.island,
      title: 'Uncharted Island',
      regionSubtitle: 'Volcanic Reefs & Untouched Jungle',
      sensoryDescription:
          'Complete silence blankets black sand shores. Massive banyan roots twist over ancient weathered steps leading into a mist-shrouded cliffside.',
      primaryEncounters: ['Beach Wreckage Exploration', 'Jungle Tripwire Traps', 'Monolithic Ascent'],
      availableClues: ['sacred_ward_fragment', 'captains_final_entry'],
    ),
    CampaignLocation.ruins: LocationMetadata(
      location: CampaignLocation.ruins,
      title: 'Sacred Ruins (Ashen Sanctum)',
      regionSubtitle: 'Subterranean Basalt Temple Sanctum',
      sensoryDescription:
          'A colossal obsidian hall lit by faint glowing moss. At the center, an empty carved pedestal waits beneath an ancient Grantha inscription.',
      primaryEncounters: ['Ashen Guardian Awakening', 'Bronze Seal Re-insertion', 'Sembiyan Showdown'],
      availableClues: ['guardian_binding_verse', 'true_purpose_of_seal'],
    ),
  };
}

class StandardDc2d6 {
  static const int easy = 7;
  static const int routine = 9;
  static const int difficult = 11;
  static const int veryDifficult = 13;
  static const int exceptional = 15;
}
