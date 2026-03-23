module room_fsm (
    input  logic clk, reset,
    input  logic n, s, e, w,
    input  logic has_sw, has_ladder, has_cape, // Item statuses
    output logic win, die,
    output logic get_sw, get_ladder, get_cape  // Item triggers
);

    // 11 distinct rooms
    typedef enum logic [3:0] {
        CC, TT, RR, SS, DD, GG, VV, WO, CH, BD, UB
    } statetype;
    
    statetype state, next_state;

    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset) state <= CC;
        else       state <= next_state;
    end

    // Next state logic
    always_comb begin
        next_state = state; // Default stay

        case (state)
            CC: begin
                if (e)      next_state = TT;
                else if (n) next_state = WO;
            end
            
            WO: begin
                if (s)      next_state = CC;
                else if (w) begin
                    // Drop requires ladder
                    if (has_ladder) next_state = SS;
                    else            next_state = GG; 
                end
            end
            
            TT: begin
                if (w)      next_state = CC;
                else if (s) next_state = RR;
                else if (n) next_state = BD;
            end
            
            RR: begin
                if (n)      next_state = TT;
                else if (s) next_state = CH;
                else if (e) next_state = DD;
            end
            
            CH: begin
                if (n)      next_state = RR;
            end
            
            SS: begin
                if (e)      next_state = RR;
            end
            
            BD: begin
                if (s)      next_state = TT;
            end
            
            DD: begin
                // Auto transition logic
                if (has_cape) next_state = UB;
                else          next_state = GG;
            end
            
            UB: begin
                // Final boss logic
                if (s && has_sw)       next_state = VV; // Win
                else if (s && !has_sw) next_state = GG; // Trap
                else if (n || e || w)  next_state = GG; // Wrong move
            end
            
            GG: begin
                // Secret escape
                if (n)      next_state = BD;
            end
            
            VV: begin
                // Locked state
                next_state = VV; 
            end
            
            default: next_state = CC;
        endcase
    end

    // Output logic
    assign win        = (state == VV);
    assign die        = (state == GG);
    
    // Item triggers based on current room
    assign get_sw     = (state == SS);
    assign get_ladder = (state == CH);
    assign get_cape   = (state == BD);

endmodule