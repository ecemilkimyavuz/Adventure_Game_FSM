module room_fsm(input logic clk, reset,
					 input logic n,s,w,e,     //Directions
					 input logic v,           //Vorpal Sword status
					 output logic win,        
					 output logic die,
					 output logic sw);        //Signal to Sword FSM
					 
 
 //Defining States
 typedef enum logic [2:0] {CC, TT, RR, SS, DD, GG, VV} statetype;
 statetype state, next_state;
 
 //Sequential Logic: State Registers
 always_ff @(posedge clk, posedge reset) begin
	if(reset)
		state <= CC;					// Return to Cave of Cacophony on reset
	else
		state <= next_state;
 end

 //Combinational Logic: Next State Logic
 always_comb begin
 next_state = state;
	case(state)
		CC: begin
			if (e) next_state = TT;                    // Only valid direction from Cave of Cacophony is East (E) to Twisty Tunnel
		    end
		TT: begin
			if (s)  next_state = RR;				// Go South to Rapid River
			else if (w) next_state = CC;			// Go West back to Cave of Cacophony
			 end
		RR: begin
			if (e) next_state = DD;				   // Go East to Dragon's Den
			else if (w) next_state = SS;			// Go West to Secret Sword Stash
			else if (n) next_state = TT;			// Go North back to Twisty Tunnel
			 end
		SS: begin
			if (e) next_state = RR;				   // Go East back to Rapid River
			 end
	   DD: begin
			if (v) next_state = VV;				   // Has sword (v=1), go to Victory Vault!
			else next_state = GG;				   // No sword (v=0), go to Grievous Graveyard...
			 end
	endcase
end

//Output Logic
assign win = (state == VV);
assign die = (state == GG);
assign sw = (state == SS); 

endmodule