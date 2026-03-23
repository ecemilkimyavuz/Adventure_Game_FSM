# Adventure_Game_FSM
# ELE432 Advanced Digital Design - Lab 1 (Preliminary Work)
**Adventure Game Finite State Machine (FSM) Implementation in SystemVerilog**

This repository contains the preliminary work for the **ELE432 Advanced Digital Design** course's first laboratory session. The project is divided into two parts: the base assignment requested in the lab manual, and an advanced, highly customized scenario designed to demonstrate a deeper understanding of digital hardware design.

---

##  Part 1: The Original Scenario (Base Assignment)
The first part of this repository (`Original_Scenario` folder) contains the standard implementation as outlined in the lab instructions. 

**Objective:** Design a synchronous Moore/Mealy Finite State Machine (FSM) for a text-based adventure game. The player starts in the *Cave of Cacophony* and must navigate through 7 specific rooms using directional inputs (N, S, E, W). To win, the player must locate the *Vorpal Sword* in the *Secret Sword Stash* before entering the *Dragon's Den*. Entering the den without the sword results in death.
* **Key Concepts Demonstrated:** Basic FSM design, state transitions, and simple conditional outputs.

---

##  Part 2: The Custom Scenario 
To further explore the capabilities of SystemVerilog and multi-module hardware design, the second part of this repository (`Custom_Scenario` folder) features a heavily expanded, custom 11-room FSM design.

**Advanced Features & Modifications:**
Instead of a simple map and a single item, this custom scenario introduces complex, unforgiving mechanics:
* **Expanded Map (11 Rooms):** The environment is significantly larger, introducing new zones like the *Carpenter's Hideout (CH)*, *Blight Depths (BD)*, and *Underbelly of the Beast (UB)*.
* **Parallel Inventory FSM (`item_fsm.sv`):** A dedicated, parallel FSM was designed to handle a persistent inventory system. The player must collect three distinct items across the map: a **Ladder**, a **Sword**, and a **Cape**.
* **Lethal Traps & Conditional Routing (`room_fsm.sv`):** State transitions now rely heavily on inventory feedback:
  * Attempting to navigate the trap room blindly without the **Ladder** results in a fatal fall.
  * Entering the Dragon's Lair automatically checks for the **Cape** to allow sneaking; otherwise, the player is instantly killed.
  * A hidden escape route was added to the death state, allowing the player to crawl back to the *Blight Depths*.

**Why this custom design?**
This expanded version was created to demonstrate robust multi-module communication, parallel FSM synchronization, and advanced conditional state logic in a hardware description language.

---

### Tools Used
* **Language:** SystemVerilog
* **Synthesis & RTL Viewing:** Intel Quartus Prime
* **Simulation & Verification:** Questa / ModelSim
