`timescale 1ns/1ps
// potential_decay_float.v (Verilog-2001, X/NaN-hardened)
// Updates on posedge `clear`. Output is decay(prev_potential); then prev<=new.

module potential_decay_float #(
    parameter integer DECAY_MODE = 0,  // 0=passthrough (debug), 1=half (default)
    parameter [31:0] INIT_POTENTIAL = 32'h00000000// +0.0f as default
)(
    input  wire        clear,
    input  wire [31:0] new_potential,           // IEEE-754 single
    output reg  [31:0] output_potential_decay   // IEEE-754 single
);
    reg [31:0] prev_potential;

    // module-scope temps (no block-scoped regs in Verilog-2001)
    reg [31:0] new_clean;
    reg [31:0] src_for_decay;

    // ---- helpers ----
    function [31:0] x2z; input [31:0] a; begin
        x2z = ((^a === 1'bx) ? 32'h00000000 : a);
    end endfunction
    function [31:0] nan2z; input [31:0] a; reg [7:0] e; reg [22:0] f; begin
        e = a[30:23]; f = a[22:0];
        nan2z = ((e==8'hFF && f!=0) ? 32'h00000000 : a); // NaN->0
    end endfunction
    function is_zero; input [31:0] a; begin
        is_zero = (a == 32'h00000000);
    end endfunction

    function [31:0] decay_half; input [31:0] x_raw;
        reg [31:0] x; reg s; reg [7:0] e; reg [22:0] f;
    begin
        x = nan2z(x2z(x_raw));
        s = x[31]; e = x[30:23]; f = x[22:0];
        if (e==8'hFF)      decay_half = x;                     // keep +/-Inf
        else if (e==8'h00) decay_half = {s,8'h00,{1'b0,f[22:1]}}; // denorm/0 >> 1
        else               decay_half = {s, e-8'd1, f};        // exp-1 => x/2
    end endfunction
    function [31:0] do_decay; input [31:0] x; begin
        do_decay = (DECAY_MODE==0) ? nan2z(x2z(x)) : decay_half(x);
    end endfunction

    initial begin
        prev_potential         = INIT_POTENTIAL;   // <<< start non-zero
        output_potential_decay = INIT_POTENTIAL;   // <<< first output also non-zero
    end

    // NORMAL: output <= decay(prev); prev <= new_clean
    // (If you want "first non-zero shows immediately", set src_for_decay=new_clean when prev==0 && new!=0.)
    always @(posedge clear) begin
        new_clean     <= nan2z(x2z(new_potential));
        src_for_decay <= prev_potential;
        output_potential_decay <= do_decay(src_for_decay);
        prev_potential         <= new_clean;
    end
endmodule
