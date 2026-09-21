# SutraDhar: Chola AI-TTRPG Companion Engine
## Master Documentation Index & Technical Specification

> **"Tactile Magic on the Table, Infinite Intelligence in the Air."**

Welcome to the definitive documentation repository for **SutraDhar**, a hybrid physical/digital tabletop roleplaying game (TTRPG) engine. SutraDhar unites the physical intimacy of tabletop gaming—printed battlemaps, physical character cards, wooden tokens, and rolling d20s—with a real-time, context-aware digital AI Game Master built in Flutter.

The debut campaign, **The Lost Ship**, immerses 4 players into the maritime and political mystery of the 11th-century Chola Empire under Rajendra Chola I.

---

## 1. Documentation Structure & Map

The `docs/` folder is cleanly segregated into functional domains to ensure complete isolation of physical specifications, digital software architectures, game rules, character sheets, and campaign narratives.

```
docs/
├── INDEX.md                                # Master index, architecture summary, navigation guide
├── prd/
│   └── PRD.md                              # Product Requirements Document
├── hld/
│   └── HLD.md                              # High-Level Architecture & System Topology
├── lld/
│   ├── LLD_SOFTWARE.md                     # Software Architecture (Flutter, Riverpod, Drift, LLM, Audio)
│   └── LLD_HARDWARE.md                     # Physical & Hardware Specifications (Maps, Cards, Tokens, Mics)
├── game_design/
│   ├── GAME_RULES_AND_MECHANICS.md         # Deterministic Rules Engine, d20 checks, DCs, combat & social
│   └── CHARACTERS_ROSTER.md                # The 6 Core Classes: Attributes, Abilities, Items & AI Integration
└── narrative/
    ├── THE_LOST_SHIP_CAMPAIGN_BIBLE.md     # 12-Chapter Scenario, Canonical Timeline, Branches & Endings
    └── HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md # Historical setting, maritime trade, guilds, educational mechanics
```

---

## 2. Directory Overviews & Direct Links

### 📋 [Product Requirements Document (PRD)](./prd/PRD.md)
Contains the core project philosophy, user personas, problem statement, feature sets across all 4 release phases, non-functional requirements (latency, battery, offline resilience), and success metrics.

### 🏛️ [High-Level Design (HLD)](./hld/HLD.md)
Documents the macro-system topology:
- **Speech-to-State Pipeline**: Dual-layer audio capture $\rightarrow$ Whisper transcription $\rightarrow$ LLM Structured Extraction.
- **Dual-Screen Topology**: Private DM Cockpit (phone/laptop) synchronized with the Public Tabletop View (tablet/TV).
- **Dual-Channel Audio Engine**: Ambient environmental bed (`just_audio`) cross-fading concurrently with low-latency dynamic Sound Effects (SFX).
- **Offline-First Persistence**: Local SQLite database via Drift ORM with state snapshotting and rollback.

### 💻 [Low-Level Design — Software](./lld/LLD_SOFTWARE.md)
Detailed implementation guide for software engineers:
- Feature-first Flutter clean architecture.
- Riverpod state models (`GameState`, `CharacterState`, `ThreatTracker`, `NpcState`, `AudioState`).
- Strict JSON schemas for Gemini 2.0 Flash / GPT-4o-mini structured tool calling.
- Deterministic rules validation engine preventing AI hallucinations of character stats or illegal moves.
- Local SQLite database schemas and event logging.

### 🎲 [Low-Level Design — Hardware & Physical Components](./lld/LLD_HARDWARE.md)
Detailed fabrication and design standards for physical artifacts:
- 24"x36" Parchment-style Battlemap design, coordinates, and regional node topology.
- Heavyweight Character Reference Cards with integrated HP slide trackers.
- Physical Card hierarchies: Clue Cards, NPC Dossiers, and Encounter/Event Cards.
- Wooden/acrylic token requirements (Supplies, Gold, Threat Clock 0–6).
- Tabletop audio hardware guidelines (boundary microphones, directional capture, Bluetooth speaker setup).

### ⚔️ [Game Rules & Mechanics](./game_design/GAME_RULES_AND_MECHANICS.md)
The complete deterministic rules manual:
- d20 + Attribute resolution engine against standard DCs (8 Easy, 11 Routine, 14 Difficult, 17 Very Difficult, 20 Exceptional).
- Resource systems: Hit Points (incapacitation at 0 HP), Supplies, Gold, and the dynamic Threat Clock (0–6).
- Action economy in combat (Move + 1 meaningful Action: Attack, Defend, Assist, Interact, Flee).
- 3-Stage Social Encounter framework (Desire $\rightarrow$ Leverage $\rightarrow$ Influence Check).
- The **Three-Clue Redundancy Rule** and Failure Consequence Tables ("Fail Forward").

### 🛡️ [Characters Roster & Archetypes](./game_design/CHARACTERS_ROSTER.md)
Exhaustive reference for all 6 playable classes:
1. **Kavalan (The Guardian / Warrior)**: High Might & Defense, frontline protection.
2. **Vēṭan (The Scout / Hunter)**: High Agility & Perception, tracking, stealth, ambushes.
3. **Vāṇiyan (The Merchant / Trader)**: High Influence, trade, resource manipulation, network connections.
4. **Kalviyalār (The Scholar / Historian)**: High Knowledge, epigraphy, clues, historical insights.
5. **Marakkalam Navigator (The Sailor / Explorer)**: High Seamanship, naval routes, weather forecasting.
6. **Thoodhuvar (The Envoy / Diplomat)**: High Influence & Knowledge, faction diplomacy, conflict mitigation.

### 📜 [The Lost Ship Campaign Bible](./narrative/THE_LOST_SHIP_CAMPAIGN_BIBLE.md)
The canonical scenario guide for the debut campaign:
- The **Fixed Truth, Flexible Routing** narrative paradigm.
- The Canonical Timeline: Ancient sacred sanctum $\rightarrow$ Removal of the Seal $\rightarrow$ Awakening of the Ashen Guardian $\rightarrow$ Flight and wreck of the *Kadal-Puli* $\rightarrow$ Arrival of Sembiyan Arul's Ashen Seekers.
- Complete 12-chapter act breakdown with decision trees, skill checks, and 5 distinct narrative endings.
- AI GM System Prompts, few-shot examples, and anti-hallucination guardrails.

### ⛵ [Historical Codex: 11th-Century Chola Empire](./narrative/HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md)
The historical and educational bedrock of the game:
- Historical backdrop of Rajaraja I and Rajendra Chola I (c. 1010–1030 CE).
- Maritime trade dynamics across the Bay of Bengal, the Andaman Sea, and Srivijaya.
- Merchant guilds (*Ainnurruvar*, *Manigramam*) and epigraphy (*Meikeerthi*, Tamil/Grantha inscriptions).
- In-game educational mechanics: rewarding players who cite authentic historical context during tabletop dialogue.

---

## 3. Core Architectural Philosophy

```
+-----------------------------------------------------------------------------------+
|                            PHYSICAL TABLETOP LAYER                                |
|  - Physical Parchment Battlemap       - 4 Physical Character Cards & Token Clips  |
|  - Real d20 Dice Rolled by Players    - Physical Clue & Event Cards Handed Out    |
+-----------------------------------------+-----------------------------------------+
                                          | Tabletop Dialogue & Dice Calls
                                          v
+-----------------------------------------------------------------------------------+
|                            DIGITAL COMPANION LAYER                                |
|  1. Audio Capture & Whisper Speech-to-Text                                        |
|  2. Semantic Extractor (LLM with Strict JSON Output Schema)                       |
|  3. Deterministic Rules Engine (Validates HP, Supplies, Clues, Threat 0-6)        |
|  4. Riverpod State Store & Drift SQLite Database                                  |
|  5. Dual-Screen Dispatcher:                                                       |
|     * DM Cockpit (Private: secret hints, rule refs, Accept/Reject queue)          |
|     * Tabletop View (Public: active map, token states, HP, atmospheric art)       |
|  6. Dynamic Audio Engine (Ambient loop crossfading + Low-latency SFX triggers)    |
+-----------------------------------------------------------------------------------+
```

### The "Fixed Truth, Flexible Routing" Rule
The AI Game Master never invents a random, uncontrolled story from thin air. Instead, it operates on a strictly validated timeline of canonical historical/narrative facts. Regardless of whether players interrogate dock workers, track footprints across the coast, or sail blindly into a squall, the AI bridges their unscripted actions to the underlying reality of the missing vessel.

---

## 4. Reading Guides by Role

- **For Software Engineers**: Begin with [PRD.md](./prd/PRD.md) $\rightarrow$ [HLD.md](./hld/HLD.md) $\rightarrow$ [LLD_SOFTWARE.md](./lld/LLD_SOFTWARE.md).
- **For Hardware & Physical Fabricators**: Read [LLD_HARDWARE.md](./lld/LLD_HARDWARE.md) $\rightarrow$ [CHARACTERS_ROSTER.md](./game_design/CHARACTERS_ROSTER.md).
- **For Game Masters & Narrative Designers**: Read [GAME_RULES_AND_MECHANICS.md](./game_design/GAME_RULES_AND_MECHANICS.md) $\rightarrow$ [THE_LOST_SHIP_CAMPAIGN_BIBLE.md](./narrative/THE_LOST_SHIP_CAMPAIGN_BIBLE.md) $\rightarrow$ [HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md](./narrative/HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md).
