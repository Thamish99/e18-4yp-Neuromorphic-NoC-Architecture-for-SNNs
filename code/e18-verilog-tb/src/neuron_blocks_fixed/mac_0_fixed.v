`timescale 1ns/1ps
// mac_float.v (IEEE-754 single) — accumulator reset at each `clear`
module mac_float (
    input  wire        CLK_Mac,
    input  wire        clear,          // asserted one cycle at end of timestep
    input  wire [31:0] weight_in,      // IEEE-754 single
    output reg  [31:0] mac_out         // IEEE-754 single
);
    reg  [31:0] acc;
    wire [31:0] a_in, b_in, sum_raw, sum;
    wire        exc_unused;

    function [31:0] x2z; input [31:0] x; begin
        x2z = ((^x === 1'bx) ? 32'h0000_0000 : x);
    end endfunction
    function [31:0] nan2z; input [31:0] x; reg [7:0] e; reg [22:0] f; begin
        e = x[30:23]; f = x[22:0];
        nan2z = ((e==8'hFF && f!=0) ? 32'h0000_0000 : x);
    end endfunction

    assign a_in = nan2z(x2z(acc));
    assign b_in = nan2z(x2z(weight_in));

    Addition_Subtraction ADD0 (
        .a_operand (a_in),
        .b_operand (b_in),
        .AddBar_Sub(1'b0),
        .Exception (exc_unused),
        .result    (sum_raw)
    );
    assign sum = nan2z(x2z(sum_raw));

    always @(posedge CLK_Mac) begin
        if (clear)      acc <= 32'h0000_0000;   // reset each timestep
        else if ((^a_in !== 1'bx) && (^b_in !== 1'bx))
                        acc <= sum;
    end

    always @(*) mac_out = acc;
endmodule
