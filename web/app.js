// SutraDhar Companion Engine Web Client
// Complete 1:1 Implementation of Chola AI-TTRPG System

// --- DATA: 6 ARCHE TYPES ---
const ARCHETYPES = [
  {
    id: 'kavalan',
    name: 'Kavalan',
    epithet: 'The Imperial Guard',
    role: 'Frontline Protector / Combat Specialist',
    hp: 14,
    might: 2,
    agility: 0,
    knowledge: 0,
    influence: 1,
    seamanship: 0,
    abilities: [
      'Shield Wall (2d6 + Might vs DC 9): Intercept up to 4 incoming physical damage targeted at an adjacent companion.',
      'Tiger Stance: Once per combat, spend 1 Stamina to add +2 to any melee attack check.'
    ],
    equipment: ['Chola Bronze Spear', 'Layered Hardened Leather Armor', 'Reinforced Wicker Shield', 'Rations (2)']
  },
  {
    id: 'vetan',
    name: 'Vēṭan',
    epithet: 'The Forest Scout',
    role: 'Tracker / Infiltrator / Survivalist',
    hp: 10,
    might: 1,
    agility: 2,
    knowledge: 1,
    influence: 0,
    seamanship: 0,
    abilities: [
      'Eagle Eye (2d6 + Agility vs DC 9): Spot concealed coastal ambushes, traps, and hidden trail markers.',
      'Silent Step: Spend 1 Stamina to roll with Advantage when sneaking past enemy sentries.'
    ],
    equipment: ['Recurve Bamboo Bow', '12 Barbed Arrows', 'Dual Hunting Daggers', 'Camouflage Cloak']
  },
  {
    id: 'vaniyan',
    name: 'Vāṇiyan',
    epithet: 'The Guild Factor',
    role: 'Merchant / Appraiser / Resource Specialist',
    hp: 10,
    might: 0,
    agility: 0,
    knowledge: 1,
    influence: 2,
    seamanship: 1,
    abilities: [
      'Merchant Bargain (2d6 + Influence vs DC 9): Secure critical items, information, or passage at half cost or for free.',
      'Appraiser: Instantly identify authenticity and historical origin of Chola metalwork and trade goods.'
    ],
    equipment: ['Ornate Ledger', 'Iron-bound Lockbox', '2 Silver Coins', 'Dravidian Trade Scales']
  },
  {
    id: 'kalviyalar',
    name: 'Kalviyalār',
    epithet: 'The Temple Epigraphist',
    role: 'Scholar / Decipherer / Historian',
    hp: 8,
    might: 0,
    agility: 0,
    knowledge: 3,
    influence: 1,
    seamanship: 0,
    abilities: [
      'Epigrapher (2d6 + Knowledge vs DC 11): Decipher ancient Dravidian runes, Grantha script, or puzzle mechanisms.',
      'Insight Surge: Start session with 2 Insight Tokens. Spend 1 token to automatically uncover 1 hidden lore clue.'
    ],
    equipment: ['Copper Inscription Plates', 'Stylus and Ink Pot', 'Palm Leaf Manuscripts', 'Magnifying Crystal']
  },
  {
    id: 'marakkalam',
    name: 'Marakkalam',
    epithet: 'The High-Seas Navigator',
    role: 'Sailor / Weather-Reader / Helmsman',
    hp: 11,
    might: 1,
    agility: 1,
    knowledge: 1,
    influence: 0,
    seamanship: 2,
    abilities: [
      'Star Reader (2d6 + Seamanship vs DC 9): Navigate treacherous waters without consuming extra supplies.',
      'Sea Legs: Gain +2 bonus on all Agility checks performed on rocking ships or wet coastal terrain.'
    ],
    equipment: ['Brass Kamal (Latitude Instrument)', 'Coir Rope (30 ft)', 'Boarding Cutlass', 'Waterproof Oilskin Map']
  },
  {
    id: 'thoodhuvar',
    name: 'Thoodhuvar',
    epithet: 'The Royal Envoy',
    role: 'Diplomat / Infiltrator / Strategist',
    hp: 9,
    might: 0,
    agility: 1,
    knowledge: 1,
    influence: 2,
    seamanship: 0,
    abilities: [
      'Silver Tongue (2d6 + Influence vs DC 9): Convince hostile or suspicious NPCs to lower weapons and negotiate.',
      'Imperial Mandate: Flash the Royal Seal to bypass local guards or gain access to restricted port archives.'
    ],
    equipment: ['Chola Court Seal', 'Silk Diplomatic Sash', 'Concealed Bodkin', 'Letter of Imperial Authority']
  }
];

// --- DATA: 7 CANONICAL LOCATIONS ---
const LOCATIONS = {
  thanjavur: {
    name: 'Thanjavur Royal Court',
    level: 1,
    chapterTitle: 'Act I: The Thanjavur Briefing',
    goal: 'Receive imperial commission and depart toward Nagapattinam.',
    narration: 'Heavy royal security surrounds the granite palace. The imperial minister unrolls the coastal map with grave urgency, pointing south toward the Bay of Bengal.',
    directives: [
      'Remind players that their assignment is to recover the sealed royal cylinder, not fight wars.',
      'Encourage the Scholar to inspect the missing ship\'s cargo manifest.',
      'If players argue over supplies, prompt them: "Does speed matter more than rations?"'
    ],
    whispers: [
      'The royal cylinder contains classified orders regarding ancient island coordinates.',
      'The court suspects someone inside the port authority helped divert the ship.'
    ],
    clues: ['imperial_court_seal', 'tampered_manifest', 'officer_route_order']
  },
  nagapattinam: {
    name: 'Nagapattinam Harbor',
    level: 1,
    chapterTitle: 'Act II / Chapter 2: Nagapattinam Harbor Sandbox',
    goal: 'Find proof of where the Kadal-Puli sailed after leaving the port.',
    narration: 'A sensory storm of fish markets, Arabic traders, foreign sails, and nervous glances. Smugglers and dock clerks whisper near the dry docks.',
    directives: [
      'Direct attention to the 4 sources: Registry Clerk Ananthan, Fisherman Muthu, the Berth, or Customs.',
      'If players are stuck, have a frightened dock worker deliberately avoid eye contact.',
      'Remember the 3-Clue Rule: either altered records, Muthu\'s testimony, or bronze fragment unlocks Coastal Village.'
    ],
    whispers: [
      'Ananthan knows the ship sailed south, but won\'t speak unless bribed with 1 Gold or assured safety.',
      'Muthu saw the ship glowing with eerie bronze light three nights ago.'
    ],
    clues: ['altered_port_records', 'muthu_night_testimony', 'bronze_rudder_fragment']
  },
  coastalVillage: {
    name: 'Coastal Fishing Village',
    level: 2,
    chapterTitle: 'Act II / Chapter 3: The Coastal Village',
    goal: 'Investigate damaged catamarans and confront the Ashen Seekers.',
    narration: 'A tense silence hangs over stilted wooden huts. Villagers huddle together while armed mercenaries intimidate them, demanding news of washed-up sailors.',
    directives: [
      'Present the moral dilemma: helping the villagers earns their trust but burns time and supplies.',
      'Allow the Envoy or Merchant to negotiate before swords are drawn.',
      'If combat starts, keep it brief—mercenaries retreat toward the Old Road once wounded.'
    ],
    whispers: [
      'Sembiyan Arul is not here yet; his lieutenant is searching for injured Chola sailors who washed ashore.',
      'Elder Muthu\'s family will reveal the inland trail if mercenaries are driven away.'
    ],
    clues: ['burned_catamaran_hull', 'mercenary_patrol_map', 'rescued_sailor_token']
  },
  oldRoad: {
    name: 'Old Inland Road & Wreck',
    level: 2,
    chapterTitle: 'Act III / Chapter 4 & 5: The Old Inland Road',
    goal: 'Follow dual tracks to the abandoned camp and locate the shipwreck.',
    narration: 'Thorny coastal scrub closes in. The Scout spots two distinct trails in the muddy ground: fleeing barefoot sailors and heavy iron-shod boots.',
    directives: [
      'Highlight Vēṭan\'s tracking ability: distinguish fleeing sailors from armed pursuers.',
      'Introduce Sembiyan Arul: he is pragmatic and willing to strike a deal rather than throw away lives.',
      'Reward discovery of the Captain\'s Journal fragment with revelation of the volcanic island.'
    ],
    whispers: [
      'Sembiyan Arul does not know the artifact is an automaton seal; he thinks it is pure gold.',
      'If players offer a truce, Sembiyan agrees to let them inspect the shipwreck peacefully.'
    ],
    clues: ['abandoned_campfire_ashes', 'captains_fragmented_journal', 'bronze_automaton_shred']
  },
  openSea: {
    name: 'Bay of Bengal Crossing',
    level: 3,
    chapterTitle: 'Act IV / Chapter 7: Crossing the Bay of Bengal',
    goal: 'Navigate the monsoon squall to reach the uncharted volcanic island.',
    narration: 'Choppy grey waves crash over the bow. Heavy squall clouds roll across the horizon. The Navigator reads the shifting winds and ocean swell.',
    directives: [
      'Offer 3 route choices: Safe Coastal Channel (2 Supplies), Fast Monsoon Channel (DC 11 Seamanship), or Hidden Current.',
      'Introduce the survivor clinging to timber: rescuing him costs 1 Supply but gives vital warning.',
      'If check fails, apply hull damage or increase Threat rather than sinking vessel.'
    ],
    whispers: [
      'The floating sailor will reveal the most critical clue: "The guardian only attacked when we pried off the seal!"'
    ],
    clues: ['storm_navigational_drift', 'survivor_critical_warning', 'sunken_reef_chart']
  },
  island: {
    name: 'Uncharted Volcanic Island',
    level: 3,
    chapterTitle: 'Act V / Chapter 8: The Uncharted Island',
    goal: 'Ascend monolithic stone steps through the jungle to the ruins.',
    narration: 'An eerie, absolute quiet. Black volcanic reefs ring the shore. Giant banyan roots swallow monolithic Dravidian stone steps rising into the mist.',
    directives: [
      'Have the Scout detect tripwires left by the panicked crew.',
      'Describe ancient Dravidian stonework growing older and grander as they climb.',
      'Build atmospheric tension as ambient sound transitions to low subterranean drones.'
    ],
    whispers: [
      'The Ashen Guardian has already detected movement on the island; every loud failure ticks Threat +1.'
    ],
    clues: ['tripwire_snare_trap', 'ancient_basalt_carving', 'guardian_echo_resonance']
  },
  ruins: {
    name: 'Sacred Ruins (Ashen Sanctum)',
    level: 4,
    chapterTitle: 'Climax / Chapters 9–12: The Sacred Ruins (Ashen Sanctum)',
    goal: 'Decide the fate of the Bronze Seal and survive the Ashen Guardian.',
    narration: 'A subterranean obsidian cathedral. The empty basalt pedestal sits in silence until heavy stone footsteps grind behind the altar. Red embers ignite in the guardian construct\'s eyes.',
    directives: [
      'Emphasize that the Guardian is a mechanism bound to protect the sanctum, not an evil deity.',
      'Allow both puzzle solutions (re-mounting the Bronze Seal) and combat tactics.',
      'When Sembiyan arrives, let players decide whether to convince him, trick him, or fight.',
      'Guide the group toward one of 5 canonical endings (Protector, Expedient, Bargain, Costly Victory, Collapse).'
    ],
    whispers: [
      'Re-inserting seal requires DC 11 Might to distract construct and DC 10 Agility to lock it in place.',
      'Surrendering seal to Sembiyan causes entire sanctum to collapse!'
    ],
    clues: ['altar_socket_lock', 'ashen_guardian_core', 'chola_dynastic_seal']
  }
};

// --- STATE DEFINITIONS ---
let sessionState = {
  selectedCharacterIds: [],
  playerNames: {},
  companionMode: 'assisted',
  sessionPacing: 'full',
  departureChoice: 'swiftDeparture'
};

let gameState = {
  location: 'thanjavur',
  threatLevel: 0,
  supplies: 8,
  gold: 3,
  discoveredClueIds: []
};

let charactersState = {};
let pendingActions = [];

// --- INITIALIZATION & LOCALSTORAGE ---
function loadPersistedSession() {
  try {
    const raw = localStorage.getItem('sutradhar_active_session');
    if (raw) {
      const parsed = JSON.parse(raw);
      sessionState = parsed;
      initGameFromSession(parsed);
      return true;
    }
  } catch (e) {
    console.error('Failed to load session:', e);
  }
  return false;
}

function savePersistedSession() {
  try {
    localStorage.setItem('sutradhar_active_session', JSON.stringify(sessionState));
  } catch (e) {
    console.error('Failed to save session:', e);
  }
}

function clearPersistedSession() {
  localStorage.removeItem('sutradhar_active_session');
  sessionState.selectedCharacterIds = [];
  sessionState.playerNames = {};
  charactersState = {};
  pendingActions = [];
}

function initGameFromSession(config) {
  let threat = 0;
  let supplies = 8;
  let gold = 3;
  const clues = [];

  switch (config.departureChoice) {
    case 'extraSupplies':
      supplies = 10;
      threat = 1;
      break;
    case 'royalSeal':
      clues.push('imperial_court_seal');
      break;
    case 'crewRecords':
      clues.push('navigator_warning_memo');
      break;
  }

  gameState = {
    location: 'thanjavur',
    threatLevel: threat,
    supplies: supplies,
    gold: gold,
    discoveredClueIds: clues
  };

  // Init 4 characters
  charactersState = {};
  for (const id of config.selectedCharacterIds) {
    const arch = ARCHETYPES.find(a => a.id === id);
    if (arch) {
      charactersState[id] = {
        ...arch,
        currentHp: arch.hp,
        maxHp: arch.hp,
        stamina: 2,
        playerName: config.playerNames[id] || ''
      };
    }
  }
}

// --- SCREEN SWITCHER ---
function showView(viewId) {
  document.querySelectorAll('.view-screen').forEach(el => el.classList.remove('active'));
  const target = document.getElementById(viewId);
  if (target) {
    target.classList.add('active');
    window.scrollTo(0, 0);
  }
}

// --- RENDER: HOME VIEW ---
function renderHomeView() {
  const slot = document.getElementById('home-card-slot');
  const hasSession = sessionState.selectedCharacterIds.length === 4;

  if (!hasSession) {
    slot.innerHTML = `
      <div class="home-card first-time">
        <h3>Begin Your Campaign</h3>
        <p>Unite the tactile joy of your physical battlemap, character cards, and 2d6 dice with an adaptive AI Game Master.</p>
        <button id="start-playing-btn" class="primary-btn">
          <span>START PLAYING</span>
          <span>➔</span>
        </button>
      </div>
    `;
    document.getElementById('start-playing-btn').addEventListener('click', () => {
      renderSetupView();
      showView('setup-view');
    });
  } else {
    let chipsHtml = '';
    for (const id of sessionState.selectedCharacterIds) {
      const arch = ARCHETYPES.find(a => a.id === id);
      const pName = sessionState.playerNames[id];
      chipsHtml += `
        <div class="party-chip-mini">
          <span class="chip-role">🛡️ ${arch ? arch.name : id}</span>
          ${pName ? `<span>(${pName})</span>` : ''}
        </div>
      `;
    }

    slot.innerHTML = `
      <div class="home-card">
        <div style="display:flex; justify-content:space-between; align-items:center;">
          <span class="status-badge in-progress">CAMPAIGN IN PROGRESS</span>
          <button id="reset-session-btn" class="mini-circle-btn" title="Reset Campaign" style="width:28px; height:28px;">🗑️</button>
        </div>
        <h3 style="margin-top: 10px;">The Lost Ship: Coromandel Coast</h3>
        <p style="margin-bottom: 8px;">Active Party (4 Heroes):</p>
        <div class="party-chips-row">${chipsHtml}</div>
        <button id="continue-session-btn" class="primary-btn">
          <span>CONTINUE SESSION</span>
          <span>➔</span>
        </button>
        <button id="new-adventure-btn" class="outline-btn">START NEW ADVENTURE</button>
      </div>
    `;

    document.getElementById('continue-session-btn').addEventListener('click', () => {
      renderCockpitView();
      showView('cockpit-view');
    });

    document.getElementById('new-adventure-btn').addEventListener('click', () => {
      renderSetupView();
      showView('setup-view');
    });

    document.getElementById('reset-session-btn').addEventListener('click', () => {
      if (confirm('Are you sure you want to reset the campaign? All progress and character state will be cleared.')) {
        clearPersistedSession();
        renderHomeView();
      }
    });
  }
}

// --- RENDER: SETUP VIEW ---
function renderSetupView() {
  const grid = document.getElementById('archetype-grid');
  grid.innerHTML = '';

  ARCHETYPES.forEach(arch => {
    const isSelected = sessionState.selectedCharacterIds.includes(arch.id);
    const card = document.createElement('div');
    card.className = `archetype-card ${isSelected ? 'selected' : ''}`;
    card.dataset.id = arch.id;

    card.innerHTML = `
      <div>
        <div class="archetype-head">
          <span class="archetype-name">${arch.name}</span>
          <span class="archetype-hp-badge">HP ${arch.hp}</span>
        </div>
        <div class="archetype-role">${arch.epithet}</div>
        <div class="attr-pills">
          <span class="attr-pill ${arch.might > 0 ? 'highlight' : ''}">Might +${arch.might}</span>
          <span class="attr-pill ${arch.agility > 0 ? 'highlight' : ''}">Agility +${arch.agility}</span>
          <span class="attr-pill ${arch.knowledge > 0 ? 'highlight' : ''}">Know +${arch.knowledge}</span>
          <span class="attr-pill ${arch.influence > 0 ? 'highlight' : ''}">Influ +${arch.influence}</span>
          <span class="attr-pill ${arch.seamanship > 0 ? 'highlight' : ''}">Sea +${arch.seamanship}</span>
        </div>
      </div>
      <div>
        <button class="lore-btn" data-id="${arch.id}">View Lore &amp; 2d6 Abilities</button>
        ${isSelected ? `
          <div class="player-input-wrap">
            <input type="text" class="player-name-input" data-id="${arch.id}" placeholder="Player Name (e.g. Aryan)" value="${sessionState.playerNames[arch.id] || ''}">
          </div>
        ` : ''}
      </div>
    `;

    // Toggle Selection on card click (unless clicking input or lore button)
    card.addEventListener('click', (e) => {
      if (e.target.closest('.lore-btn') || e.target.closest('input')) return;

      const id = arch.id;
      if (sessionState.selectedCharacterIds.includes(id)) {
        sessionState.selectedCharacterIds = sessionState.selectedCharacterIds.filter(x => x !== id);
      } else {
        if (sessionState.selectedCharacterIds.length < 4) {
          sessionState.selectedCharacterIds.push(id);
        }
      }
      updateSetupRosterState();
      renderSetupView();
    });

    grid.appendChild(card);
  });

  // Attach Player Name input listeners
  document.querySelectorAll('.player-name-input').forEach(input => {
    input.addEventListener('input', (e) => {
      const id = e.target.dataset.id;
      sessionState.playerNames[id] = e.target.value;
    });
  });

  // Attach Lore buttons
  document.querySelectorAll('.lore-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      openLoreModal(btn.dataset.id);
    });
  });

  updateSetupRosterState();
}

function updateSetupRosterState() {
  const count = sessionState.selectedCharacterIds.length;
  const counter = document.getElementById('roster-counter');
  const status = document.getElementById('launch-status');
  const btn = document.getElementById('embark-btn');

  counter.textContent = `${count} / 4 Selected`;
  if (count === 4) {
    counter.classList.add('ready');
    status.textContent = 'Party Ready (4/4 Selected)';
    status.classList.add('ready');
    btn.removeAttribute('disabled');
  } else {
    counter.classList.remove('ready');
    status.textContent = `Select ${4 - count} more character${4 - count > 1 ? 's' : ''}`;
    status.classList.remove('ready');
    btn.setAttribute('disabled', 'true');
  }
}

function openLoreModal(archId) {
  const arch = ARCHETYPES.find(a => a.id === archId);
  if (!arch) return;

  document.getElementById('modal-char-name').textContent = arch.name;
  document.getElementById('modal-char-epithet').textContent = arch.epithet;
  document.getElementById('modal-char-hp').textContent = `Base HP: ${arch.hp} • Max Stamina: 2`;

  const list = document.getElementById('modal-char-abilities');
  list.innerHTML = '';
  arch.abilities.forEach(ab => {
    const li = document.createElement('li');
    li.textContent = ab;
    list.appendChild(li);
  });

  document.getElementById('modal-char-equipment').textContent = arch.equipment.join(' • ');
  document.getElementById('char-modal').classList.add('open');
}

// --- RENDER: DM COCKPIT VIEW ---
function renderCockpitView() {
  const loc = LOCATIONS[gameState.location] || LOCATIONS.thanjavur;

  // 1. App Bar Updates
  document.getElementById('cockpit-location-label').textContent = `11th C. Chola • ${loc.name}`;
  updateResourceBar();

  // 2. Party Health HUD
  const hudContainer = document.getElementById('cockpit-party-hud');
  hudContainer.innerHTML = '';
  Object.values(charactersState).forEach(char => {
    const hpPercent = Math.max(0, Math.min(100, (char.currentHp / char.maxHp) * 100));
    const isLow = (char.currentHp / char.maxHp) <= 0.35;

    const card = document.createElement('div');
    card.className = `hud-char-card ${isLow ? 'low-hp' : ''}`;
    card.innerHTML = `
      <div class="hud-head">
        <span class="hud-name">${char.name}</span>
        <span class="hud-hp-num">${char.currentHp}/${char.maxHp} HP</span>
      </div>
      ${char.playerName ? `<span class="hud-player-name">Player: ${char.playerName}</span>` : ''}
      <div class="hp-bar-track">
        <div class="hp-bar-fill" style="width: ${hpPercent}%;"></div>
      </div>
      <div class="hud-foot">
        <span class="hud-stamina">Stamina: ${char.stamina}</span>
        <div class="hud-hp-btns">
          <button class="mini-circle-btn minus-hp" data-id="${char.id}" title="Damage -1 HP">-</button>
          <button class="mini-circle-btn plus-hp" data-id="${char.id}" title="Heal +1 HP">+</button>
        </div>
      </div>
    `;

    card.querySelector('.minus-hp').addEventListener('click', () => {
      char.currentHp = Math.max(0, char.currentHp - 1);
      renderCockpitView();
    });

    card.querySelector('.plus-hp').addEventListener('click', () => {
      char.currentHp = Math.min(char.maxHp, char.currentHp + 1);
      renderCockpitView();
    });

    hudContainer.appendChild(card);
  });

  // 3. Action Review Queue
  renderActionQueue();

  // 4. Storyline Guidance Engine
  document.getElementById('guidance-chapter-title').textContent = loc.chapterTitle.toUpperCase();
  document.getElementById('guidance-location-sub').textContent = `${loc.name} • Suggested Level: ${loc.level}`;
  document.getElementById('location-select').value = gameState.location;

  // Threat alert
  const alertBox = document.getElementById('threat-alert-box');
  const alertText = document.getElementById('threat-alert-text');
  if (gameState.threatLevel >= 4) {
    alertBox.style.display = 'flex';
    alertText.textContent = `CRITICAL THREAT (${gameState.threatLevel}/6): Mercenaries are actively ambushing the party or ancient temple stones are crumbling!`;
  } else if (gameState.threatLevel >= 2) {
    alertBox.style.display = 'flex';
    alertText.textContent = `ELEVATED THREAT (${gameState.threatLevel}/6): NPCs are becoming wary of being seen talking to the players.`;
  } else {
    alertBox.style.display = 'none';
  }

  // Objective & Atmospheric
  document.getElementById('objective-text').textContent = loc.goal;
  document.getElementById('atmospheric-text').textContent = `"${loc.narration}"`;

  // Directives
  const dirList = document.getElementById('directives-list');
  dirList.innerHTML = '';
  loc.directives.forEach(d => {
    const item = document.createElement('div');
    item.className = 'directive-item';
    item.innerHTML = `<span class="directive-bullet">•</span><span>${d}</span>`;
    dirList.appendChild(item);
  });

  // Whispers
  const whispList = document.getElementById('whispers-list');
  whispList.innerHTML = '';
  loc.whispers.forEach(w => {
    const item = document.createElement('div');
    item.className = 'whisper-item';
    item.innerHTML = `<span>🔒</span><span>${w}</span>`;
    whispList.appendChild(item);
  });

  // Clues
  const cluesList = document.getElementById('clues-list');
  cluesList.innerHTML = '';
  const clueChipsWrap = document.createElement('div');
  clueChipsWrap.className = 'clue-chips-wrap';

  loc.clues.forEach(c => {
    const discovered = gameState.discoveredClueIds.includes(c);
    const chip = document.createElement('div');
    chip.className = 'clue-chip';
    chip.innerHTML = `
      <span>${discovered ? '✓' : '❓'}</span>
      <span style="${discovered ? 'color: var(--verdigris); font-weight: bold;' : ''}">${c.replace(/_/g, ' ').toUpperCase()} ${discovered ? '(Found)' : '(Hidden)'}</span>
    `;
    clueChipsWrap.appendChild(chip);
  });
  cluesList.appendChild(clueChipsWrap);
}

function updateResourceBar() {
  const tChip = document.getElementById('threat-chip');
  const tVal = document.getElementById('threat-val');
  tVal.textContent = `Threat ${gameState.threatLevel}/6`;
  tChip.className = 'resource-chip threat-chip';
  if (gameState.threatLevel >= 4) {
    tChip.classList.add('critical');
  } else if (gameState.threatLevel >= 2) {
    tChip.classList.add('elevated');
  }

  document.getElementById('supplies-val').textContent = `${gameState.supplies} Rations`;
  document.getElementById('gold-val').textContent = `${gameState.gold} Gold`;
}

function renderActionQueue() {
  const container = document.getElementById('action-queue-container');
  const label = document.getElementById('queue-count-label');
  const dismissBtn = document.getElementById('dismiss-all-btn');

  label.textContent = `ACTION REVIEW QUEUE (${pendingActions.length} PENDING)`;
  dismissBtn.style.display = pendingActions.length > 0 ? 'inline-block' : 'none';

  if (pendingActions.length === 0) {
    container.innerHTML = `
      <div style="text-align: center; padding: 20px; color: var(--parchment-muted); font-size: 0.85rem; border: 1px dashed var(--granite-border); border-radius: 10px;">
        Awaiting player speech transcript or physical 2d6 action input...
      </div>
    `;
    return;
  }

  container.innerHTML = '';
  pendingActions.forEach((delta, index) => {
    const card = document.createElement('div');
    card.className = `action-card ${delta.type.toLowerCase()}`;

    let evalHtml = '';
    if (delta.evaluation) {
      const e = delta.evaluation;
      evalHtml = `
        <div class="eval-badge ${e.isSuccess ? '' : 'failed'}">
          <span>${e.formulaSummary}</span>
          <span class="eval-tag ${e.isSuccess ? 'success' : 'fail'}">
            ${e.isCritSuccess ? 'CRIT SUCCESS (12)' : (e.isCritFail ? 'CRIT FAIL (2)' : (e.isSuccess ? 'SUCCESS' : 'FAILED'))}
          </span>
        </div>
      `;
    }

    let deltasHtml = '';
    const pills = [];
    if (delta.threatDelta) pills.push(`<span class="delta-pill ${delta.threatDelta > 0 ? 'neg' : 'pos'}">Threat ${delta.threatDelta > 0 ? '+' : ''}${delta.threatDelta}</span>`);
    if (delta.suppliesDelta) pills.push(`<span class="delta-pill neg">Supplies ${delta.suppliesDelta}</span>`);
    if (delta.goldDelta) pills.push(`<span class="delta-pill neutral">Gold ${delta.goldDelta > 0 ? '+' : ''}${delta.goldDelta}</span>`);
    if (delta.hpDelta) {
      Object.entries(delta.hpDelta).forEach(([cId, hp]) => {
        pills.push(`<span class="delta-pill ${hp < 0 ? 'neg' : 'pos'}">${cId.toUpperCase()} HP ${hp > 0 ? '+' : ''}${hp}</span>`);
      });
    }
    if (delta.clues && delta.clues.length > 0) {
      delta.clues.forEach(cl => pills.push(`<span class="delta-pill pos">New Clue: ${cl}</span>`));
    }

    if (pills.length > 0) {
      deltasHtml = `
        <div class="deltas-wrap">
          <span class="deltas-label">State Changes to Apply:</span>
          <div class="deltas-pills">${pills.join('')}</div>
        </div>
      `;
    }

    card.innerHTML = `
      <div class="action-card-header">
        <span>${delta.type} • ${delta.actingName}</span>
        <span style="font-size: 0.7rem; color: var(--parchment-muted);">AI PROPOSED</span>
      </div>
      <div class="action-card-body">
        ${evalHtml}
        <div>
          <span class="box-label">Narration (Read Aloud):</span>
          <p class="narration-prose">"${delta.narration}"</p>
        </div>
        ${delta.secretNote ? `
          <div class="secret-whisper-box">
            <span>🔒</span>
            <div><strong>Secret DM Note:</strong> ${delta.secretNote}</div>
          </div>
        ` : ''}
        ${deltasHtml}
        <div class="action-btns-row">
          <button class="reject-btn" data-index="${index}">REJECT</button>
          <button class="accept-btn" data-index="${index}">ACCEPT DELTA</button>
        </div>
      </div>
    `;

    card.querySelector('.reject-btn').addEventListener('click', () => {
      pendingActions.splice(index, 1);
      renderActionQueue();
    });

    card.querySelector('.accept-btn').addEventListener('click', () => {
      applyActionDelta(delta);
      pendingActions.splice(index, 1);
      renderCockpitView();
    });

    container.appendChild(card);
  });
}

function applyActionDelta(delta) {
  if (delta.threatDelta) {
    gameState.threatLevel = Math.max(0, Math.min(6, gameState.threatLevel + delta.threatDelta));
  }
  if (delta.suppliesDelta) {
    gameState.supplies = Math.max(0, gameState.supplies + delta.suppliesDelta);
  }
  if (delta.goldDelta) {
    gameState.gold = Math.max(0, gameState.gold + delta.goldDelta);
  }
  if (delta.hpDelta) {
    Object.entries(delta.hpDelta).forEach(([cId, hp]) => {
      if (charactersState[cId]) {
        charactersState[cId].currentHp = Math.max(0, Math.min(charactersState[cId].maxHp, charactersState[cId].currentHp + hp));
      }
    });
  }
  if (delta.clues) {
    delta.clues.forEach(c => {
      if (!gameState.discoveredClueIds.includes(c)) {
        gameState.discoveredClueIds.push(c);
      }
    });
  }
}

// --- 2D6 PARSER & AI LOGIC ---
function parseSpeechToDelta(transcript) {
  const lower = transcript.toLowerCase();

  // 1. Identify acting character
  let charId = 'kavalan';
  for (const id of Object.keys(charactersState)) {
    const c = charactersState[id];
    if (lower.includes(id) || lower.includes(c.name.toLowerCase())) {
      charId = id;
      break;
    }
  }
  const char = charactersState[charId] || ARCHETYPES[0];

  // 2. Identify 2d6 dice rolls
  let die1 = 4;
  let die2 = 3;
  const diceMatch = lower.match(/(\d)\s*(?:and|\+|,)\s*(\d)/);
  const singleMatch = lower.match(/(?:rolled|got|roll|score)\s*(?:a|an)?\s*(\d+)/);

  if (diceMatch) {
    die1 = Math.max(1, Math.min(6, parseInt(diceMatch[1], 10)));
    die2 = Math.max(1, Math.min(6, parseInt(diceMatch[2], 10)));
  } else if (singleMatch) {
    const tot = parseInt(singleMatch[1], 10);
    die1 = Math.max(1, Math.min(6, Math.floor(tot / 2)));
    die2 = Math.max(1, Math.min(6, tot - die1));
  }

  // 3. Identify Attribute & DC
  let attribute = 'might';
  let mod = char.might;
  let targetDc = 9; // Routine

  if (lower.includes('agil') || lower.includes('sneak') || lower.includes('bow') || lower.includes('dodge')) {
    attribute = 'agility';
    mod = char.agility;
  } else if (lower.includes('know') || lower.includes('inscript') || lower.includes('read') || lower.includes('study')) {
    attribute = 'knowledge';
    mod = char.knowledge;
    targetDc = 11; // Difficult
  } else if (lower.includes('influ') || lower.includes('convince') || lower.includes('bribe') || lower.includes('talk')) {
    attribute = 'influence';
    mod = char.influence;
  } else if (lower.includes('sea') || lower.includes('sail') || lower.includes('storm') || lower.includes('steer')) {
    attribute = 'seamanship';
    mod = char.seamanship;
  }

  // Evaluate 2d6: (Die1 + Die2) + Mod vs DC
  const diceSum = die1 + die2;
  const totalScore = diceSum + mod;
  const isCritSuccess = (die1 === 6 && die2 === 6);
  const isCritFail = (die1 === 1 && die2 === 1);
  const isSuccess = isCritSuccess || (!isCritFail && totalScore >= targetDc);

  const evaluation = {
    die1,
    die2,
    mod,
    totalScore,
    targetDc,
    isSuccess,
    isCritSuccess,
    isCritFail,
    formulaSummary: `2d6 [${die1}+${die2}] + ${mod} = ${totalScore} vs DC ${targetDc}`
  };

  // 4. Derive Consequences
  let type = 'SKILL CHECK';
  let threatDelta = 0;
  let suppliesDelta = 0;
  let goldDelta = 0;
  const hpDelta = {};
  const clues = [];
  let narration = '';
  let secretNote = '';

  if (lower.includes('attack') || lower.includes('strike') || lower.includes('spear') || lower.includes('fight')) {
    type = 'COMBAT ACTION';
    if (isSuccess) {
      narration = `${char.name}'s bronze blade flashes in the sun! The strike penetrates the enemy guard, driving them back with a sharp clash.`;
      secretNote = 'The hostile fighters are reeling. One more solid blow or an Influence check will cause them to surrender.';
    } else {
      hpDelta[char.id] = -2;
      threatDelta = 1;
      narration = `${char.name} lunges boldly, but the mercenary parries sharply, delivering a bruising counter-strike (-2 HP). Threat escalates!`;
      secretNote = 'Advise the players that retreat or taking defensive stance (Guard) will mitigate further harm.';
    }
  } else if (lower.includes('travel') || lower.includes('sail') || lower.includes('head to') || lower.includes('road')) {
    type = 'TRAVEL';
    suppliesDelta = -1;
    narration = `The party marches through the coastal scrub under the tropical sun, consuming rations along the journey (-1 Supply).`;
    secretNote = 'Describe the smell of sea salt and burning wood as they near the next waypoint.';
  } else {
    type = 'INVESTIGATION';
    if (isSuccess) {
      clues.push(`${gameState.location}_clue_${gameState.discoveredClueIds.length + 1}`);
      narration = `${char.name} meticulously searches the area. Beneath layers of sand and palm fronds, an unmistakable clue is unearthed.`;
      secretNote = 'Direct the player to read aloud the clue card corresponding to this scene.';
    } else {
      threatDelta = 1;
      narration = `The investigation takes too long. Footsteps in the distance signal that hostile patrols have drawn closer (+1 Threat).`;
      secretNote = 'Allow them to continue searching, but any further failure will trigger an ambush.';
    }
  }

  return {
    type,
    actingName: char.name,
    evaluation,
    threatDelta,
    suppliesDelta,
    goldDelta,
    hpDelta,
    clues,
    narration,
    secretNote
  };
}

// --- ATTACH EVENT LISTENERS ---
document.addEventListener('DOMContentLoaded', () => {
  const hasSession = loadPersistedSession();
  renderHomeView();

  // Setup Back Button
  document.getElementById('setup-back-btn').addEventListener('click', () => {
    renderHomeView();
    showView('home-view');
  });

  // Companion Mode Cards
  document.querySelectorAll('[data-mode]').forEach(card => {
    card.addEventListener('click', () => {
      document.querySelectorAll('[data-mode]').forEach(c => c.classList.remove('selected'));
      card.classList.add('selected');
      sessionState.companionMode = card.dataset.mode;
    });
  });

  // Session Pacing Cards
  document.querySelectorAll('[data-pacing]').forEach(card => {
    card.addEventListener('click', () => {
      document.querySelectorAll('[data-pacing]').forEach(c => c.classList.remove('selected'));
      card.classList.add('selected');
      sessionState.sessionPacing = card.dataset.pacing;
    });
  });

  // Departure Radios
  document.querySelectorAll('input[name="departure"]').forEach(radio => {
    radio.addEventListener('change', (e) => {
      document.querySelectorAll('.radio-card').forEach(rc => rc.classList.remove('selected'));
      e.target.closest('.radio-card').classList.add('selected');
      sessionState.departureChoice = e.target.value;
    });
  });

  // Embark on Mission Button
  document.getElementById('embark-btn').addEventListener('click', () => {
    if (sessionState.selectedCharacterIds.length === 4) {
      savePersistedSession();
      initGameFromSession(sessionState);
      renderCockpitView();
      showView('cockpit-view');
    }
  });

  // Cockpit Resource Adjusters
  document.getElementById('threat-minus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.threatLevel = Math.max(0, gameState.threatLevel - 1);
    renderCockpitView();
  });
  document.getElementById('threat-plus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.threatLevel = Math.min(6, gameState.threatLevel + 1);
    renderCockpitView();
  });
  document.getElementById('supplies-minus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.supplies = Math.max(0, gameState.supplies - 1);
    renderCockpitView();
  });
  document.getElementById('supplies-plus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.supplies += 1;
    renderCockpitView();
  });
  document.getElementById('gold-minus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.gold = Math.max(0, gameState.gold - 1);
    renderCockpitView();
  });
  document.getElementById('gold-plus').addEventListener('click', (e) => {
    e.stopPropagation();
    gameState.gold += 1;
    renderCockpitView();
  });

  // Cockpit Home Button
  document.getElementById('cockpit-home-btn').addEventListener('click', () => {
    renderHomeView();
    showView('home-view');
  });

  // Dismiss All Action Queue
  document.getElementById('dismiss-all-btn').addEventListener('click', () => {
    pendingActions = [];
    renderActionQueue();
  });

  // Travel Selector
  document.getElementById('location-select').addEventListener('change', (e) => {
    gameState.location = e.target.value;
    renderCockpitView();
  });

  // Accordion Toggles
  document.querySelectorAll('.accordion-toggle').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.closest('.accordion-item');
      item.classList.toggle('open');
      const chev = btn.querySelector('.acc-chevron');
      chev.textContent = item.classList.contains('open') ? '▲' : '▼';
    });
  });

  // Push to Talk Button (Simulated Mic)
  const pttBtn = document.getElementById('ptt-btn');
  const speechInput = document.getElementById('speech-transcript-input');
  const spinner = document.getElementById('ai-status-spinner');

  let isListening = false;
  pttBtn.addEventListener('click', () => {
    isListening = !isListening;
    if (isListening) {
      pttBtn.classList.add('listening');
      pttBtn.querySelector('.ptt-text').textContent = 'Listening...';
      document.getElementById('mic-status-text').textContent = 'LISTENING TO PLAYERS...';
      // Simulate incoming voice transcription after 1.2s
      setTimeout(() => {
        speechInput.value = 'Kavalan strikes the mercenary with spear, rolling 4 and 5';
        pttBtn.classList.remove('listening');
        pttBtn.querySelector('.ptt-text').textContent = 'Push to Talk';
        document.getElementById('mic-status-text').textContent = 'PLAYER SPEECH & 2D6 PHYSICAL INPUT';
        isListening = false;
      }, 1300);
    } else {
      pttBtn.classList.remove('listening');
      pttBtn.querySelector('.ptt-text').textContent = 'Push to Talk';
      document.getElementById('mic-status-text').textContent = 'PLAYER SPEECH & 2D6 PHYSICAL INPUT';
    }
  });

  // Process Speech Button
  function handleProcessSpeech(text) {
    if (!text.trim()) return;
    spinner.style.display = 'block';

    setTimeout(() => {
      const delta = parseSpeechToDelta(text);
      pendingActions.unshift(delta);
      speechInput.value = '';
      spinner.style.display = 'none';
      renderActionQueue();
    }, 350);
  }

  document.getElementById('process-speech-btn').addEventListener('click', () => {
    handleProcessSpeech(speechInput.value);
  });

  speechInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      handleProcessSpeech(speechInput.value);
    }
  });

  // Quick Simulation Chips
  document.querySelectorAll('.sim-chip').forEach(chip => {
    chip.addEventListener('click', () => {
      speechInput.value = chip.dataset.text;
      handleProcessSpeech(chip.dataset.text);
    });
  });

  // Modal Close Button
  document.getElementById('modal-close-btn').addEventListener('click', () => {
    document.getElementById('char-modal').classList.remove('open');
  });
  document.getElementById('char-modal').addEventListener('click', (e) => {
    if (e.target.id === 'char-modal') {
      document.getElementById('char-modal').classList.remove('open');
    }
  });
});
