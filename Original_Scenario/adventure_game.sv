module adventure_game (input logic clk, reset,
							  input logic n, s, e, w,
							  output logic win, die);
							  
							  
//Connecting the two FSMs.
logic sw_wire;						//Signal from Room FSM to Sword FSM ("Get Sword")
logic v_wire; 						// Signal from Sword FSM to Room FSM ("Has Sword")

//Instantiate Room FSM
// Format: .port_name_inside_module(wire_name_in_top_level)
room_fsm room_inst(
.clk(clk),
.reset(reset),
.n(n), .s(s), .e(e), .w(w),
.v(v_wire),    					 // Input: "Has sword" status from sword_fsm
.win(win), 
.die(die),
.sw(sw_wire)    					 // Output: "Get sword" command to sword_fsm
);

//Instantiate Sword FSM
sword_fsm sword_inst(
.clk(clk), 
.reset(reset),
.sw(sw_wire),   					 // Input: "Get sword" command from room_fsm
.v(v_wire)      					 // Output: "Has sword" status to room_fsm
);

endmodule