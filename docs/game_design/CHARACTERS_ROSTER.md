# Playable Characters Roster & Archetypes
## SutraDhar: Chola AI-TTRPG Companion Engine

| Document Version | System Balance State | Playable Classes | Roster Scope |
| :--- | :--- | :--- | :--- |
| **v1.0.0** | Mathematically Balanced | 6 Specialized Archetypes | The Lost Ship Campaign |

---

## 1. Roster Overview & Design Intent

In SutraDhar, characters are designed with **sharp specialization**. No single character can solve every challenge.
- Combat challenges require the **Kavalan**.
- Wilderness tracking and traps require the **Vēṭan**.
- Commercial leverage and port gossip require the **Vāṇiyan**.
- Inscriptions, ancient ruins, and secret records require the **Kalviyalār**.
- Navigating the Bay of Bengal and surviving monsoon squalls require the **Marakkalam Navigator**.
- Delicate political diplomacy and court negotiation require the **Thoodhuvar**.

For a standard 4-player game, players choose any 4 of these 6 characters.

---

## 2. Comparative Mathematical Attributes Table

| Character | Class / Role | Base HP | Might | Agility | Knowledge | Influence | Seamanship | Unique Resource Pool |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Kavalan** | Guardian / Warrior | **14** | **+5** | **+3** | **+1** | **+2** | **+2** | 2 Stamina Tokens |
| **Vēṭan** | Scout / Hunter | **11** | **+3** | **+5** | **+2** | **+2** | **+3** | 2 Stamina Tokens |
| **Vāṇiyan** | Merchant / Trader | **10** | **+2** | **+2** | **+3** | **+5** | **+4** | 3 Personal Gold |
| **Kalviyalār** | Scholar / Historian | **9** | **+1** | **+2** | **+5** | **+4** | **+2** | 2 Insight Tokens |
| **Marakkalam** | Sailor / Navigator | **11** | **+2** | **+3** | **+3** | **+2** | **+5** | 2 Extra Supplies |
| **Thoodhuvar** | Envoy / Diplomat | **10** | **+2** | **+2** | **+4** | **+5** | **+2** | 2 Influence Tokens |

---

## 3. Exhaustive Character Dossiers

---

### 3.1 Kavalan (The Guardian / Frontline Protector)
> *"Stand behind my shield. Nothing crosses this threshold while I draw breath."*

- **Historical Background**: Trained in the imperial garrison traditions of the Chola military, the Kavalan represents the disciplined elite infantry who guarded royal shipments, temples, and coastal garrisons.
- **Base HP**: 14 (Highest in game)
- **Attribute Modifiers**: Might: `+5` | Agility: `+3` | Knowledge: `+1` | Influence: `+2` | Seamanship: `+2`
- **Class Abilities**:
  - **Guard (Active Reaction)**: Once per combat round, when an enemy successfully attacks an adjacent ally, the Kavalan can intercept the blow, taking the damage on their own shield and reducing the incoming damage by $1$.
  - **Powerful Strike (Active Bonus)**: Spend **1 Stamina** before rolling an attack to add **+3** to any Might-based combat roll.
- **Starting Equipment**:
  - Heavy Bronze-Tipped Chola Spear ($1\text{d6}+1$ damage)
  - Teak & Bronze Studded Shield ($+2$ personal Defense)
  - Travel Cloak and 2 Stamina Tokens
- **Roleplay Prompts**: Direct, loyal, suspicious of deceit, prioritizes the physical safety of the party above all else.
- **AI Game Master Parsing Hook**: When the player says *"I jump in front of the Scholar"*, the AI immediately maps this to the `Guard` ability without requiring explicit menu navigation.

---

### 3.2 Vēṭan (The Scout / Wilderness Hunter)
> *"The mud tells a story that words cannot hide."*

- **Historical Background**: Descended from the indigenous forest and coastal trackers of the Tamil country, the Vēṭan reads the wind, flora, and footprints with uncanny precision.
- **Base HP**: 11
- **Attribute Modifiers**: Might: `+3` | Agility: `+5` | Knowledge: `+2` | Influence: `+2` | Seamanship: `+3`
- **Class Abilities**:
  - **Tracker (Passive Boon)**: On any successful Agility or Knowledge check related to following physical tracks or environmental signs, reveal **one additional actionable fact** (e.g., number of pursuers, how long ago they passed, or whether they were injured).
  - **Ambush (Active Combat)**: If the party successfully sneaks up on an enemy or strikes from concealment, add **+3** to the initial attack roll and deal an extra $+1\text{d4}$ surprise damage.
- **Starting Equipment**:
  - Recurve Composite Bow ($1\text{d6}$ damage)
  - Hunting Knife ($1\text{d4}$ damage)
  - Coiled Hemp Climbing Rope ($50\text{ ft}$) and 2 Stamina Tokens
- **Roleplay Prompts**: Quiet, observant, prefers open skies to crowded court chambers, alert to sudden environmental shifts.

---

### 3.3 Vāṇiyan (The Merchant / Trade Guild Factor)
> *"Every man has a price, every port has a ledger, and every ship leaves a debt."*

- **Historical Background**: A seasoned factor representing the powerful *Ainnurruvar* (Five Hundred Lords of Ayyavole) merchant guild. The Vāṇiyan navigates the complex web of trade charters, customs tariffs, and maritime syndicates.
- **Base HP**: 10
- **Attribute Modifiers**: Might: `+2` | Agility: `+2` | Knowledge: `+3` | Influence: `+5` | Seamanship: `+4`
- **Class Abilities**:
  - **Bargain (Passive Perk)**: Can reduce the resource cost of any reasonable purchase, bribe, or ship charter by **1 Gold** once per settlement.
  - **Connections (Active Narrative Trigger)**: Once per chapter, the player can declare: *"I have a guild contact in this settlement who owes me a favor."* The AI Game Master automatically generates a plausible NPC contact with Helpful disposition who provides local advice or resources.
- **Starting Equipment**:
  - Merchant Guild Ledger & Seal
  - Bag of Exotic Spice Samples (for bartering)
  - 3 Stamped Gold Coins (Kasu)
- **Roleplay Prompts**: Affable, calculating, hates unnecessary bloodshed which disrupts commerce, treats information as currency.

---

### 3.4 Kalviyalār (The Scholar / Royal Epigraphist)
> *"Stones do not lie. If an inscription was erased, it was erased out of fear."*

- **Historical Background**: A court scholar educated in the great temple libraries of Thanjavur. The Kalviyalār is fluent in Old Tamil, Grantha, and Sanskrit, specializing in royal decrees, temple endowments, and bronze metallurgy.
- **Base HP**: 9
- **Attribute Modifiers**: Might: `+1` | Agility: `+2` | Knowledge: `+5` | Influence: `+4` | Seamanship: `+2`
- **Class Abilities**:
  - **Read the Past (Passive Epigraphy)**: When examining an ancient inscription, damaged manuscript, or carved bronze artifact, ask the GM/AI for **one additional piece of historical context** upon any successful Knowledge check.
  - **Insight (Active Investigation)**: Once per major location, spend **1 Insight Token** to ask the GM/AI: *"What is the most important clue or inconsistency we have overlooked in this scene?"* The AI is required to provide a true, actionable hint.
- **Starting Equipment**:
  - Palm-Leaf Writing Folio & Iron Stylus
  - Brass Oil Lamp
  - Bundle of Rubbing Papers & Charcoal
  - 2 Insight Tokens
- **Roleplay Prompts**: Methodical, curious, fascinated by forgotten history, physically vulnerable but intellectually indispensable.

---

### 3.5 Marakkalam Navigator (The Sailor / Master Helmsman)
> *"The wind shifts before the cloud appears. Respect the sea, or she will keep your bones."*

- **Historical Background**: A veteran of the Chola merchant fleets navigating between Nagapattinam, the Andaman Islands, and the Malacca Straits. Master of seasonal monsoon navigation and catamaran handling.
- **Base HP**: 11
- **Attribute Modifiers**: Might: `+2` | Agility: `+3` | Knowledge: `+3` | Influence: `+2` | Seamanship: `+5`
- **Class Abilities**:
  - **Read the Sea (Passive Environmental)**: Can automatically identify incoming storm squalls, dangerous coastal shoals, or abnormal current patterns without requiring a check.
  - **Master Navigator (Active Travel)**: When travelling across the Open Sea, the party receives an **additional alternative route choice** (e.g., discovering the "Hidden Channel" that bypasses storm damage).
- **Starting Equipment**:
  - Bronze Navigational Pointer & Sun-Stone Compass
  - Heavy Rigging Knife
  - Waterproof Waxed Travel Sack with 2 Extra Supplies
- **Roleplay Prompts**: Superstitious regarding oceanic omens, practical, pragmatic, respects the raw power of the monsoon.

---

### 3.6 Thoodhuvar (The Envoy / Imperial Diplomat)
> *"A sharp tongue cuts deeper than a bronze sword, and repairs what iron can only break."*

- **Historical Background**: An accredited royal emissary carrying the authority and seal of the Chola throne. The Thoodhuvar is trained in statecraft, protocol, and resolving disputes between vassal kings, foreign traders, and rival factions.
- **Base HP**: 10
- **Attribute Modifiers**: Might: `+2` | Agility: `+2` | Knowledge: `+4` | Influence: `+5` | Seamanship: `+2`
- **Class Abilities**:
  - **Diplomatic Immunity (Active De-escalation)**: Once per major social confrontation, when an encounter is about to erupt into hostile combat, the Thoodhuvar can present imperial credentials to force a **temporary ceasefire** for 3 minutes of dialogue.
  - **Persuade (Active Reroll)**: Spend **1 Influence Token** to reroll any failed Influence check during a social encounter.
- **Starting Equipment**:
  - Imperial Chola Court Seal of Authority
  - Fine Embroidered Silk Shawl
  - Official Letters of Passage
  - 2 Influence Tokens
- **Roleplay Prompts**: Polished, eloquent, acutely aware of social rank and hierarchy, seeks honorable political compromises.

---

## 4. Class Synergy Matrix

```
+-------------------+-------------------------------------------------------------------------+
| Character Pair    | Unique Mechanical / Narrative Synergy                                   |
+-------------------+-------------------------------------------------------------------------+
| Kavalan + Scholar | "The Sword & The Pen": Kavalan shields the fragile Kalviyalār while the|
|                   | Scholar spends rounds deciphering combat puzzle mechanisms in ruins.    |
| Vēṭan + Navigator | "The Wayfinders": Combines land tracking with maritime navigation to    |
|                   | unlock secret shortcuts across coastal inlets and rocky reefs.          |
| Merchant + Envoy  | "The Dual Ambassadors": Dominate any social encounter by pairing guild |
|                   | economic leverage (Gold) with Chola imperial political authority.      |
| Scout + Guardian  | "Tactical Vanguard": Vēṭan identifies enemy positions for an ambush,   |
|                   | allowing the Kavalan to charge with guaranteed surprise advantage.     |
+-------------------+-------------------------------------------------------------------------+
```

---

## 5. AI Game Master Prompt Directives by Archetype

When the AI companion parses table dialogue, it enforces the following archetype awareness:
1. **Highlighting Archetype Strengths**: If a Scholar examines an inscription, the AI output should use academic vocabulary and historical lore; if a Merchant examines the same stone, the AI highlights its potential market value and craftsmanship origin.
2. **Preventing Class Encroachment**: If the Kavalan attempts to decipher ancient Grantha without the Scholar, the AI sets a steep DC 17 check; if the Scholar does it, the DC drops to routine DC 11.
3. **Recognizing Natural Language Triggers**:
   - *"I use my connections to find a smuggler"* $\rightarrow$ Invokes Vāṇiyan's `Connections` ability.
   - *"I step in and invoke royal authority before they draw swords"* $\rightarrow$ Invokes Thoodhuvar's `Diplomatic Immunity`.
   - *"I spend an insight token to figure out what we missed"* $\rightarrow$ Invokes Kalviyalār's `Insight`.
