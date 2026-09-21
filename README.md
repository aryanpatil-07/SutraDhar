# SutraDhar: Chola AI-TTRPG Companion Engine

> **A Hybrid Physical/Digital Tabletop Roleplaying Game Platform**  
> *"Tactile Magic on the Table, Infinite Intelligence in the Air."*

SutraDhar is an AI-powered tabletop companion engine built in Flutter that bridges the tactile joy of traditional tabletop gaming (physical battlemaps, character cards, tokens, rolling physical 2d6 dice) with dynamic digital state tracking, ambient acoustic orchestration (`just_audio`), and context-aware narrative co-piloting.

The debut campaign, **The Lost Ship**, is an immersive mystery set in the 11th-century Chola Empire during the golden age of maritime trade under Rajendra Chola I.

---

## 🏛️ Comprehensive Project Documentation

The complete architectural, design, narrative, and rules documentation is housed in the [`docs/`](./docs/INDEX.md) directory:

| Section | Description | Key Reference |
| :--- | :--- | :--- |
| **Project Overview & Index** | Master navigation map & architectural principles | [docs/INDEX.md](./docs/INDEX.md) |
| **Product Requirements** | PRD, Personas, Phased Roadmap (Phases 1–4), NFRs | [docs/prd/PRD.md](./docs/prd/PRD.md) |
| **High-Level Design** | Macro-architecture, speech pipeline, dual-screen topology | [docs/hld/HLD.md](./docs/hld/HLD.md) |
| **Software Low-Level Design** | Flutter Clean Architecture, Riverpod, Drift DB, LLM JSON Schemas, `just_audio` | [docs/lld/LLD_SOFTWARE.md](./docs/lld/LLD_SOFTWARE.md) |
| **Hardware & Physical Specs** | 24"x36" Battlemap, 350 GSM cards, dice, tokens, microphones | [docs/lld/LLD_HARDWARE.md](./docs/lld/LLD_HARDWARE.md) |
| **Game Rules & Mechanics** | 2d6 Checks, DCs, Threat Clock (0–6), Combat, 3-Stage Social, 3-Clue Rule | [docs/game_design/GAME_RULES_AND_MECHANICS.md](./docs/game_design/GAME_RULES_AND_MECHANICS.md) |
| **Playable Characters Roster** | Complete stats & abilities for all 6 classes (Kavalan, Vēṭan, Vāṇiyan, Kalviyalār, Marakkalam, Thoodhuvar) | [docs/game_design/CHARACTERS_ROSTER.md](./docs/game_design/CHARACTERS_ROSTER.md) |
| **Campaign Bible: The Lost Ship** | Full 12-Chapter Scenario, Canonical Timeline, 5 Endings, AI Prompts | [docs/narrative/THE_LOST_SHIP_CAMPAIGN_BIBLE.md](./docs/narrative/THE_LOST_SHIP_CAMPAIGN_BIBLE.md) |
| **Historical Codex** | 11th-century Chola history, merchant guilds, navigation, educational rules | [docs/narrative/HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md](./docs/narrative/HISTORICAL_CODEX_11TH_CENTURY_CHOLA.md) |

---

## 🎲 Core Architectural Pillars

1. **Physical-First, Digital-Ambient**: Players roll real 2d6 dice, touch real cards, and look at each other across a physical battlemap.
2. **Deterministic Rules, Generative Narration**: Mathematics, dice checks, health points, and inventory are governed by strict, unyielding deterministic code. The AI handles narrative prose, dialogue flavor, and consequence descriptions.
3. **Fixed Truth, Flexible Routing**: The underlying mystery timeline is absolute and immutable. The AI's job is not to generate random plotlines, but to adapt player choices to this canonical truth.
4. **Speech-to-State Transcription**: The app captures table dialogue, transcribes it via Whisper, extracts structured JSON deltas, and presents them in a private DM Cockpit.
5. **Dual-Channel Audio Engine**: Ambient environmental loops crossfade seamlessly while one-shot sound effects trigger with sub-150ms latency.
