# Product Requirements Document (PRD)
## SutraDhar: Chola AI-TTRPG Companion Engine

| Document Version | Status | Author | Target Campaign | Date |
| :--- | :--- | :--- | :--- | :--- |
| **v1.0.0** | Approved | SutraDhar Core Team | The Lost Ship (11th-Century Chola) | September 2026 |

---

## 1. Executive Summary & Product Vision

Traditional Tabletop Roleplaying Games (TTRPGs) such as Dungeons & Dragons provide unmatched social camaraderie and tactile satisfaction: rolling physical dice, moving miniatures, and gathering with friends. However, they place an immense cognitive burden on the human Game Master (GM), who must memorize hundreds of pages of rules, track numerical states (HP, stamina, spell slots, inventory, initiative), manage pacing, roleplay multiple non-player characters (NPCs), and curate background music. Conversely, Virtual Tabletops (VTTs) automate bookkeeping but trap players behind laptops, destroying the tactile essence of the game.

**SutraDhar** resolves this dichotomy by creating a **hybrid physical-digital TTRPG companion engine**. Players sit around a physical table with a printed battlemap, physical character cards, wooden tokens, and physical d20 dice. Meanwhile, a digital engine running in Flutter listens to the gameplay via ambient microphones, transcribes the table dialogue, uses a Large Language Model (LLM) with strict JSON schemas to extract state changes, validates those actions against a deterministic rules engine, orchestrates cross-fading ambient soundscapes, and powers a dual-screen interface (a private **DM Cockpit** for the human GM and a public **Tabletop View** for the players).

The debut adventure, **The Lost Ship**, places four players into the maritime mystery of the 11th-century Chola Empire, combining gripping mystery with authentic historical exploration.

---

## 2. Problem Statement & Market Pain Points

1. **The "GM Burnout" Crisis**: 82% of tabletop groups stall due to a lack of available Game Masters. Running a game requires simultaneous bookkeeping, improvisation, rule adjudications, and audio curation.
2. **Loss of Tactile Tabletop Joy**: Modern digital solutions force players onto screens, turning social gaming into video games played through browser tabs.
3. **Railroading vs. Hallucination in AI RPGs**: Pure AI dungeon masters either hallucinate impossible rule changes, lose track of inventory, or generate incoherent, meandering narratives without mystery structure.
4. **Educational Disconnect**: Games with historical themes often feel like dry educational lectures rather than immersive gameplay.

---

## 3. Product Principles & Philosophy

- **Physical-First, Digital-Ambient**: If a mechanic can be physical (rolling dice, touching tokens, moving cards), it stays physical. The digital engine is an invisible, ambient co-host, not a screen barrier.
- **Deterministic Rules, Generative Narration**: Mathematics, dice checks, health points, and inventory are governed by strict, unyielding deterministic code. The AI only handles narrative prose, dialogue flavor, and consequence descriptions.
- **Fixed Truth, Flexible Routing**: The underlying mystery timeline is absolute and immutable. The AI's job is not to generate random plotlines, but to adapt player choices to this canonical truth.
- **Failure as Story Momentum**: A failed d20 check never produces a dead-end "nothing happens" state. It always extracts a cost: raising the Threat Track, consuming Supplies, altering NPC trust, or introducing unexpected obstacles.
- **Subtle Historical Immersion**: Historical facts about 11th-century Chola maritime trade, court bureaucracy, and navigation are woven into clues and mechanics, granting in-game advantages to observant players.

---

## 4. User Personas

### Persona A: The Overburdened Game Master ("Aditya")
- **Profile**: 28 years old, loves storytelling and gathering friends, but works 50 hours a week and lacks 10 hours to prepare campaign notes, battlemaps, and audio playlists.
- **Needs**: An intelligent co-pilot that automatically tracks character health, reminds him of NPC motives, suggests situational consequences, and triggers sound effects without taking away his authority.

### Persona B: The Tactile Player ("Meera")
- **Profile**: 24 years old, loves board games, tactile card games, and social deduction. Strongly dislikes sitting in front of a laptop after working all day on a computer.
- **Needs**: Real dice to roll, beautiful physical character sheets, tangible tokens, and atmospheric music that brings the table to life.

### Persona C: The Convention / Hackathon Judge ("Dr. Raman")
- **Profile**: Has 5 to 10 minutes to evaluate whether the project is a functional, novel system or just a generic chatbot wrapper.
- **Needs**: Immediate visual clarity: sees the physical board, watches a dice roll get parsed by voice in under 2 seconds, observes the soundscape change immediately, and witnesses state updates on the public screen.

---

## 5. Feature Scope & Release Phases

```
+----------------------------------------------------------------------------------------------------+
|                                    PRODUCT DEVELOPMENT ROADMAP                                     |
+--------------------+--------------------+-------------------------+--------------------------------+
|  Phase 1: Core     |  Phase 2: Audio    |  Phase 3: Public        |  Phase 4: Multi-Device         |
|  Engine & Cockpit  |  & Atmosphere      |  Map Viewer             |  Sync & RAG Memory             |
+--------------------+--------------------+-------------------------+--------------------------------+
| - Flutter App Core | - just_audio dual  | - Player Tabletop View  | - Supabase/WebRTC Realtime     |
| - Whisper STT      |   channel engine   | - InteractiveViewer map | - Local Vector RAG Memory      |
| - LLM JSON Schema  | - Crossfade loop   | - Dynamic fog-of-war    | - Long-term NPC relationship   |
| - Riverpod State   | - Event SFX triggers| - Token indicators     |   history across sessions      |
| - DM Accept/Reject | - Audio mappings   | - HP / Initiative HUD   | - Multi-device DM/Player pair  |
+--------------------+--------------------+-------------------------+--------------------------------+
```

### Phase 1: Core Engine & DM Cockpit (Current MVP)
- **Speech-to-State Transcription**: Push-to-Talk (PTT) microphone capture streaming table dialogue to OpenAI Whisper or local STT models.
- **LLM Structured Parser**: Gemini 2.0 Flash / GPT-4o-mini structured prompt extracting character actions, skill checks, damage, and location changes in a validated JSON schema.
- **Deterministic Rules Engine**: Validates extracted values against core game rules (caps HP at max, enforces DC thresholds, tracks stamina and supplies).
- **Private DM Cockpit UI**:
  - Live transcription stream.
  - "Accept / Reject / Edit" pending action queue before committing to state.
  - Quick-action manual override buttons (Damage, Heal, Add Supply, Increment Threat).
  - Secret GM prompts and NPC background motives.
- **Local Persistence**: Offline-first campaign and session storage using SQLite (Drift ORM).

### Phase 2: Dynamic Audio & Atmosphere Layer
- **Dual-Channel Audio Engine (`just_audio` + `audio_session`)**:
  - **Channel 1 (Ambient Loop)**: Continuous, seamless looping environmental audio (e.g., bustling port, open sea winds, ancient crypt silence) that cross-fades smoothly over 2–4 seconds upon location transitions.
  - **Channel 2 (One-Shot SFX)**: Immediate, low-latency playback of sound effects triggered by state changes (e.g., sword clashing, dice rolling, stone door sliding open, thunder strike).
- **Audio Mapping Engine**: Semantic tag mapping linking LLM output tags (`"sfx": "sword_strike"`, `"ambient": "sea_storm"`) to bundled local audio assets.

### Phase 3: Public Map Viewer (Tabletop View)
- **Player-Facing Display**: Landscape UI designed for a tabletop tablet, secondary monitor, or living-room TV.
- **Interactive Map Canvas**: Built with Flutter `InteractiveViewer`, rendering the high-resolution Chola territory map.
- **Fog of War & Zone Revealing**: Dynamically unmasks regions (Nagapattinam, Coastal Village, The Island, The Ruins) as the party discovers clues.
- **Public Party HUD**: Real-time display of character tokens, HP bars, Supplies, Gold, and the public Threat Clock (0–6).

### Phase 4: Multi-Device Sync & RAG Memory
- **Real-Time Device Synchronization**: Zero-configuration pairing between the DM's smartphone and the public TV/tablet using local network WebSockets or cloud-based Supabase Realtime.
- **Retrieval-Augmented Generation (RAG) Memory**: Embedding-based local vector store enabling the AI to recall nuanced NPC interactions, promises made in previous chapters, and player-specific choices across multi-hour campaigns.

---

## 6. Functional Requirements

### FR-1: Audio Capture & Speech-to-Text (STT)
- **FR-1.1**: The system must provide a Push-to-Talk (PTT) button and an optional voice-activity detection (VAD) toggle on the DM Cockpit.
- **FR-1.2**: Table dialogue audio chunks must be sent to Whisper API (or local Whisper tiny/base) in 16kHz WAV/M4A format.
- **FR-1.3**: The returned transcript must appear in the DM Cockpit within 1,200 ms of audio capture completion.

### FR-2: AI State Extraction & JSON Conformance
- **FR-2.1**: Transcribed dialogue must be passed to the LLM همراه with current game state context (`location`, `threat`, `supplies`, `characters_hp`, `active_clues`).
- **FR-2.2**: The LLM must return a strict JSON payload matching the `GameStateDelta` schema containing:
  - `action_type`: `MOVE`, `CHECK`, `COMBAT`, `DIALOGUE`, `REST`, `RESOURCE_CHANGE`
  - `character_id`: Targeted character (`kavalan`, `vetan`, `vaniyan`, `kalviyalar`, `marakkalam`, `thoodhuvar`)
  - `check_details`: `{ stat, roll, dc, success }`
  - `state_deltas`: `{ hp_delta, supplies_delta, gold_delta, threat_delta }`
  - `narration`: Short, atmospheric 2–3 sentence description.
  - `audio_triggers`: `{ ambient_track, sfx_cue }`
- **FR-2.3**: If the LLM generates an invalid payload, the system must trigger a deterministic fallback and present a manual adjudication prompt to the human DM.

### FR-3: The DM Verification Queue
- **FR-3.1**: Every AI-generated state change must enter an "Action Pending" queue in the DM Cockpit.
- **FR-3.2**: The human DM can tap **Accept** (commits state and dispatches audio/UI updates), **Edit** (modifies numbers), or **Reject** (discards without applying).
- **FR-3.3**: The DM can enable "Autonomous Co-Pilot Mode" for casual games, where non-lethal state changes apply automatically after a 5-second countdown.

### FR-4: Dual-Channel Audio Management
- **FR-4.1**: Ambient environmental music must loop seamlessly without perceptible gaps or clicks.
- **FR-4.2**: Cross-fading between ambient zones must follow an equal-power or linear volume curve over a configurable duration (default: 3.0 seconds).
- **FR-4.3**: One-shot SFX must trigger concurrently without interrupting or ducking the ambient track unless specified by a dramatic sting cue.

---

## 7. Non-Functional Requirements (NFRs)

| Metric | Requirement | Justification |
| :--- | :--- | :--- |
| **End-to-End Latency** | $\le 2.5\text{ seconds}$ | From the moment the DM releases PTT to the state proposal appearing on screen. |
| **Offline Resilience** | 100% Core Rules Offline | The game must remain fully playable with manual inputs even if internet/LLM connection fails. |
| **Audio Latency** | $\le 150\text{ ms}$ for SFX | Instant auditory feedback preserves tactile tabletop immersion. |
| **Battery Consumption** | $\le 18\%\text{ per hour}$ | A typical 3-hour tabletop session must not drain a mobile device completely. |
| **Memory Footprint** | $\le 250\text{ MB}$ RAM | Enables smooth performance on budget tablets and older smartphones. |
| **Cross-Platform** | Flutter (Android, iOS, macOS, Windows) | Support for any tablet, laptop, or mobile device at the table. |

---

## 8. Physical / Hardware Scope & Segregation

To preserve tabletop magic, physical equipment requirements are strictly documented:
- **Battlemap**: 24" x 36" printed parchment map of the Chola coastline. No embedded wires, RFID, or cameras are required.
- **Character Reference Cards**: High-durability 350 GSM matte cards detailing stats, stamina counters, and abilities.
- **Physical Dice**: Standard tabletop polyhedral d20 dice rolled by players onto the table.
- **Clue, Event & NPC Cards**: Physical cards handed to players upon discovery.
- **Tokens**: Wooden Supply tokens, Gold tokens, and an acrylic Threat Clock (0–6).
- **Audio Hardware**: Recommended standard Bluetooth speaker positioned under or beside the table.

---

## 9. Success Metrics & Key Performance Indicators (KPIs)

1. **Tabletop Engagement Ratio**: Over 80% of player conversation during a session should be between players and looking at the physical board, rather than staring at the companion app.
2. **DM Cognitive Load Reduction**: Measured by a $\ge 50\%$ reduction in GM prep time and zero manual book lookups during play.
3. **Turn Turnaround Time**: Resolving complex skill checks or travel events within $\le 45\text{ seconds}$ total.
4. **Historical Knowledge Retention**: In user playtests, $\ge 70\%$ of players recall authentic historical facts about Chola trade, ports, and navigation after one session of *The Lost Ship*.
