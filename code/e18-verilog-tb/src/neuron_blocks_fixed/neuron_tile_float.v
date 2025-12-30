`timescale 1ns/1ps
module neuron_tile_float
#(
    parameter integer ID = 0,    // 0..N-1
    parameter integer AW = 10,
    parameter [31:0] V_THRESHOLD = 32'h3F800000// 0.5f for bring-up
)
(
    input  wire        CLK,
    input  wire        rst_n,
    input  wire        clear,

    input  wire        bus_valid,
    input  wire [AW-1:0] bus_dst_id,
    input  wire [31:0] bus_weight,

    output wire        spike,
    output wire [31:0] v_mem
);
    wire match      = bus_valid && (bus_dst_id == ID[AW-1:0]);
    wire [31:0] wi  = match ? bus_weight : 32'h0000_0000;

    wire [31:0] mac_out, v_dec, v_new;
    wire        spk;

    mac_float MAC (
        .CLK_Mac (CLK),
        .clear   (clear),
        .weight_in(wi),
        .mac_out (mac_out)
    );

    potential_adder_float #(.V_THRESHOLD(V_THRESHOLD)) PAD (
        .clear            (clear),
        .input_weight     (mac_out),
        .decayed_potential(v_dec),
        .final_potential  (v_new),
        .spike            (spk)
    );

potential_decay_float #(
    .DECAY_MODE(1),
    .INIT_POTENTIAL(32'h3F800000) // +1.0f
) DEC (
    .clear                  (clear),
    .new_potential          (v_new),
    .output_potential_decay (v_dec)
);

    assign spike = spk;
    assign v_mem = v_new;
endmodule
