### 3.1. Custom Game Rules & Specifications: "Advanced 11-Room Scenario"

In this custom implementation, the base laboratory assignment was significantly expanded from a simple 7-room map to a highly complex, 11-room Finite State Machine (FSM). The objective was to design an unforgiving, "Dark Souls"-inspired environment that requires multi-module communication, strategic item collection, and precise navigation to achieve victory.

**1. Multi-Item Inventory System (`item_fsm.sv`)**

Instead of tracking a single item, the game now features a persistent inventory system managed by a parallel, independent FSM. The player must explore the map to collect three distinct items:

* **The Ladder:** Acquired in the Carpenter's Hideout (`CH`).
* **The Sword:** Acquired in the Secret Sword Stash (`SS`).
* **The Cape:** Acquired in the Blight Depths (`BD`).

**2. Lethal Traps and Conditional Routing (`room_fsm.sv`)**

The state transitions are no longer purely directional; they are heavily dependent on the feedback signals from the inventory FSM (`has_ladder`, `has_cape`, `has_sw`).

* **The Pitfall Trap (Room WO):** If the player attempts to move West blindly, the system checks for the Ladder. Without it, the player falls to their death (`GG`). With the Ladder, they safely climb down to the Secret Sword Stash (`SS`).

* **The Dragon's Lair (Room DD & UB):** Entering the Dragon's Den (`DD`) triggers an automatic conditional check without waiting for the next clock cycle's directional input. Possessing the Cape allows the player to successfully sneak into the Underbelly of the Beast (`UB`). If the Cape is missing, the player is instantly killed (`GG`).

* **The Final Strike (Room UB):** Once under the dragon, the player has only one correct move. They must strike South (`s`) while possessing the Sword to reach the Victory Vault (`VV`). Any other directional input, or lacking the sword, results in immediate death (`GG`).

* **Secret Graveyard Escape (Room GG):** To add a layer of depth to the gameplay, the death state (`GG`) is not entirely locked. A hidden escape route via the North (`n`) input allows the player to crawl out of the graveyard and respawn in the Blight Depths (`BD`).
