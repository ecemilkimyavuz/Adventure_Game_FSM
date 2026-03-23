module testbench;

    //Declare internal variables to connect to our DUT (adventure_game)
    logic clk;
    logic reset;
    logic n, s, e, w;
    
    // Outputs from DUT
    logic win, die;

    //Instantiate the Device Under Test (DUT)
    adventure_game dut (
        .clk(clk),
        .reset(reset),
        .n(n), .s(s), .e(e), .w(w),
        .win(win),
        .die(die)
    );

    //Generate the clock signal (toggle every 5 time units)
    always begin
        clk = 1; #5;  // High for 5 units
        clk = 0; #5;  // Low for 5 units
    end

    //The actual test scenario 
    initial begin
        // Release all directional keys
        n = 0; s = 0; e = 0; w = 0; 

        // Apply reset to start the game fresh in Cave of Cacophony (CC)
        reset = 1; @(posedge clk); #1; // Wait for a clock edge, then a tiny bit
        reset = 0; @(posedge clk); #1;

        $display("--- Starting WINNING Sequence ---");

        // SCENARIO 1: THE WINNING PATH 
        // Route: CC(e)->TT(s)->RR(w)->SS(e)->RR(e)->DD(wait)->VV
       
  		  // Move East from CC to TT
        e = 1; @(posedge clk); #1; e = 0; @(posedge clk); #1;
        
        // Move South from TT to RR
        s = 1; @(posedge clk); #1; s = 0; @(posedge clk); #1;
        
        // Move West from RR to SS (Secret Sword Stash - Pick up sword!)
        w = 1; @(posedge clk); #1; w = 0; @(posedge clk); #1;
        
        // Move East from SS back to RR
        e = 1; @(posedge clk); #1; e = 0; @(posedge clk); #1;
        
        // Move East from RR to DD (Dragon's Den)
        e = 1; @(posedge clk); #1; e = 0; @(posedge clk); #1;
        
        // In DD, player MUST NOT provide inputs. The FSM will automatically 
        // transition to VV (Victory Vault) on the next clock edge because we have the sword.
        @(posedge clk); #1; 

        //SELF-CHECKING FOR WIN
        if (win === 1'b1 && die === 1'b0) begin
            $display("SUCCESS: Player WON the game! (Sword obtained)");
        end else begin
            $display("ERROR: Player did NOT win! Something is wrong in the winning path.");
        end

        // RESET BETWEEN GAMES 
        
        $display("--- Resetting Game ---");
        reset = 1; @(posedge clk); #1; 
        reset = 0; @(posedge clk); #1;

        $display("--- Starting LOSING (DIE) Sequence ---");

        
        // SCENARIO 2: THE LOSING PATH (Devoured by Dragon)
        // Route: CC(e)->TT(s)->RR(e)->DD(wait)->GG
        
        // Move East from CC to TT
        e = 1; @(posedge clk); #1; e = 0; @(posedge clk); #1;
        
        // Move South from TT to RR
        s = 1; @(posedge clk); #1; s = 0; @(posedge clk); #1;
        
        // Move East directly from RR to DD (Without going West to get the sword!)
        e = 1; @(posedge clk); #1; e = 0; @(posedge clk); #1;
        
        // In DD, wait for the FSM to transition automatically. 
        // Since we have NO sword, it should go to GG (Grievous Graveyard).
        @(posedge clk); #1; 

        //SELF-CHECKING FOR DIE 
        if (die === 1'b1 && win === 1'b0) begin
            $display("SUCCESS: Player DIED! (Entered Dragon's Den without sword)");
        end else begin
            $display("ERROR: Player did NOT die! Something is wrong in the losing path.");
        end

        // END OF SIMULATION
        $display("--- Simulation Completed ---");
        $stop; // Pauses the simulation in ModelSim/Quartus so you can view waveforms
        
    end

endmodule