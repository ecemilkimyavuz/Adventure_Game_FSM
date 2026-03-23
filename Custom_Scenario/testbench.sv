module testbench();

    logic clk, reset;
    logic n, s, e, w;
    logic win, die;

    // Instantiate Top-Level Design
    myadventure_game dut (
        .clk(clk),
        .reset(reset),
        .n(n), .s(s), .e(e), .w(w),
        .win(win),
        .die(die)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Main testing block
    initial begin
        // Initialize inputs
        clk = 0; reset = 0;
        n = 0; s = 0; e = 0; w = 0;

        // Apply global reset
        $display("SYSTEM RESET");
        reset = 1; #10;
        reset = 0; #10;

        
        // Scenario 1: The Epic Win Sequence
        
        $display("STARTING WIN SEQUENCE");
        
        // Get Ladder (CC -> TT -> RR -> CH)
        e = 1; #10; e = 0; #10; // East to TT
        s = 1; #10; s = 0; #10; // South to RR
        s = 1; #10; s = 0; #10; // South to CH (Acquired Ladder)
        
        // Get Sword (CH -> RR -> TT -> CC -> WO -> SS)
        n = 1; #10; n = 0; #10; // North to RR
        n = 1; #10; n = 0; #10; // North to TT
        w = 1; #10; w = 0; #10; // West to CC
        n = 1; #10; n = 0; #10; // North to WO (Trap Room)
        w = 1; #10; w = 0; #10; // West drop to SS (Acquired Sword, survived via Ladder)
        
        // Get Cape (SS -> RR -> TT -> BD)
        e = 1; #10; e = 0; #10; // East to RR
        n = 1; #10; n = 0; #10; // North to TT
        n = 1; #10; n = 0; #10; // North to BD (Acquired Cape)
        
        // Face the Boss (BD -> TT -> RR -> DD -> UB -> VV)
        s = 1; #10; s = 0; #10; 							// South to TT
        s = 1; #10; s = 0; #10; 							// South to RR
        e = 1; #10; e = 0; #10; 							// East to DD (Auto-sneak to UB via Cape)
        s = 1; #10; s = 0; #10;						   // Strike South to VV (Victory via Sword)

        // Self-check Win Condition
        if (win === 1'b1 && die === 1'b0)
            $display("SUCCESS: Player WON the epic game!");
        else
            $display("ERROR: Win path failed!");

        
        // Scenario 2: The Tragic Death Sequence
        
        $display("SYSTEM RESET");
        reset = 1; #10;
        reset = 0; #10;
        
        $display("STARTING DIE SEQUENCE");
        
        // Jump into pit without a ladder (CC -> WO -> GG)
        n = 1; #10; n = 0; #10; // North to WO
        w = 1; #10; w = 0; #10; // Jump West blindly... DIE! (No Ladder)

        // Self-check Die Condition
        if (die === 1'b1 && win === 1'b0)
            $display("SUCCESS: Player DIED by falling!");
        else
            $display("ERROR: Die path failed!");

        // End simulation
        $display("SIMULATION COMPLETED");
        $stop;
    end

endmodule