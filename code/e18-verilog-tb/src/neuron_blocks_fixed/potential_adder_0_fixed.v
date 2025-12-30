`timescale 1ns/1ps
// potential_adder_float.v (Verilog-2001, X/NaN-hardened)
module potential_adder_float #(
    parameter [31:0] V_THRESHOLD = 32'h3E99999A  // 0.3f for bring-up; raise later
)(
    input  wire        clear,                   // 1-cycle pulse per timestep
    input  wire [31:0] input_weight,           // IEEE-754 single
    input  wire [31:0] decayed_potential,      // IEEE-754 single
    output reg  [31:0] final_potential,        // IEEE-754 single
    output reg         spike
);
    // helpers
    function [31:0] x2z; input [31:0] a; begin
        x2z = ((^a === 1'bx) ? 32'h00000000 : a);
    end endfunction
    function [31:0] nan2z; input [31:0] a; reg [7:0] e; reg [22:0] f; begin
        e = a[30:23]; f = a[22:0];
        nan2z = ((e==8'hFF && f!=0) ? 32'h00000000 : a);
    end endfunction
    function fgt; input [31:0] a,b;
        reg sa,sb; reg [7:0] ea,eb; reg [22:0] fa,fb;
    begin
        sa=a[31]; ea=a[30:23]; fa=a[22:0];
        sb=b[31]; eb=b[30:23]; fb=b[22:0];
        if (sa!=sb)      fgt = (sb==1'b1);     // + > -
        else if (sa==1'b0) fgt = (ea!=eb)?(ea>eb):(fa>fb);   // both +
        else               fgt = (ea!=eb)?(ea<eb):(fa<fb);   // both -, reversed
    end endfunction

    wire [31:0] a_in = nan2z(x2z(decayed_potential));
    wire [31:0] b_in = nan2z(x2z(input_weight));

    wire [31:0] sum_raw;
    wire [31:0] sum_clean;
    wire        exc_unused;

    // your floating-point adder
    Addition_Subtraction ADD0 (
        .a_operand (a_in),
        .b_operand (b_in),
        .AddBar_Sub(1'b0),       // add
        .Exception (exc_unused),
        .result    (sum_raw)
    );
    assign sum_clean = nan2z(x2z(sum_raw));

    initial begin
        final_potential = 32'h00000000;
        spike           = 1'b0;
    end

    always @(posedge clear) begin
        final_potential <= sum_clean;
        spike           <= fgt(sum_clean, V_THRESHOLD);
    end
endmodule
