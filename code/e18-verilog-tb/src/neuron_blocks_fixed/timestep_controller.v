`timescale 1ns/1ps
module timestep_controller_single (
    input  wire CLK,
    input  wire rst_n,
    input  wire done_i,
    output reg  clear_o
);
    reg arm, started;
    always @(posedge CLK) begin
        if (!rst_n) begin
            clear_o <= 1'b0;
            arm     <= 1'b1;   // bootstrap
            started <= 1'b0;
        end else begin
            started <= 1'b1;
            clear_o <= 1'b0;
            if (!done_i) arm <= 1'b1;
            if (done_i && arm && started) begin
                clear_o <= 1'b1;   // 1-cycle pulse
                arm     <= 1'b0;
            end
        end
    end
endmodule
