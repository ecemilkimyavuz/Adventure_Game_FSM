module myadventure_game (
    input  logic clk, reset,
    input  logic n, s, e, w,
    output logic win, die
);

    // Internal wires for FSM communication
    logic get_sw_w, get_ladder_w, get_cape_w;
    logic has_sw_w, has_ladder_w, has_cape_w;

    // Instantiate Room FSM (Game Logic & Map)
    room_fsm room_inst (
        .clk(clk),
        .reset(reset),
        .n(n), .s(s), .e(e), .w(w),
        .has_sw(has_sw_w),
        .has_ladder(has_ladder_w),
        .has_cape(has_cape_w),
        .win(win),
        .die(die),
        .get_sw(get_sw_w),
        .get_ladder(get_ladder_w),
        .get_cape(get_cape_w)
    );

    // Instantiate Item FSM (Inventory System)
    item_fsm item_inst (
        .clk(clk),
        .reset(reset),
        .get_sw(get_sw_w),
        .get_ladder(get_ladder_w),
        .get_cape(get_cape_w),
        .has_sw(has_sw_w),
        .has_ladder(has_ladder_w),
        .has_cape(has_cape_w)
    );

endmodule