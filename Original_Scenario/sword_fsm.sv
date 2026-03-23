module sword_fsm( input logic clk, reset,
						input logic sw,				// "Get sword" signal from Room FSM
						output logic v);				// "Has sword" signal to Room FSM
	


//Defining States: no_sword and has_sword
typedef enum logic {no_sword, has_sword} statetype;
statetype state, next_state;

//Sequential Logic: State Registers
 always_ff @(posedge clk, posedge reset) begin
	if(reset)
		state <= no_sword;					
	else
		state <= next_state;
 end

//Combinational Logic: Next State Logic
    always_comb begin
        next_state = state; // Default: Stay in current state
        
        case (state)
            no_sword: begin
                if (sw) next_state = has_sword;
					 else next_state = no_sword; 
            end
            
            has_sword: begin
                //Do nothing! Sword stays with the player until next reset.
            end
        endcase
    end
//Output Logic
    assign v = (state == has_sword); 

endmodule