module item_fsm (
    input  logic clk, reset,
    
    // Item acquisition triggers from room FSM
    input  logic get_sw, get_ladder, get_cape,
    
    // Current inventory status
    output logic has_sw, has_ladder, has_cape
);

    // Sequential logic: Inventory memory
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear inventory on reset
            has_sw     <= 1'b0;
            has_ladder <= 1'b0;
            has_cape   <= 1'b0;
        end else begin
            // Retain items once acquired
            if (get_sw)     has_sw     <= 1'b1;
            if (get_ladder) has_ladder <= 1'b1;
            if (get_cape)   has_cape   <= 1'b1;
        end
    end

endmodule