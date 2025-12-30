`timescale 1ns/1ps
// One shared ROM for all layers/neurons with 20 explicit read ports.
// File: "weights_all.hex"
// Indexing: flat_idx = (layer_id << (AW + TGT_BITS)) + (target_id << AW) + source_id
// Typical params here: AW=4 (16 sources), TGT_BITS=4 (up to 16 targets), LYR_BITS=1 (2 layers)

module conn_weight_rom_multi20
#(
    parameter AW        = 4,  // log2(sources per target)
    parameter TGT_BITS  = 4,  // log2(targets per layer)
    parameter LYR_BITS  = 1   // log2(number of layers)
)
(
    // ---- 20 read ports: src*/tgt*/lyr* in, weight* out ----
    input  wire [AW-1:0]       src0,  input wire [TGT_BITS-1:0] tgt0,  input wire [LYR_BITS-1:0] lyr0,  output reg [31:0] weight0,
    input  wire [AW-1:0]       src1,  input wire [TGT_BITS-1:0] tgt1,  input wire [LYR_BITS-1:0] lyr1,  output reg [31:0] weight1,
    input  wire [AW-1:0]       src2,  input wire [TGT_BITS-1:0] tgt2,  input wire [LYR_BITS-1:0] lyr2,  output reg [31:0] weight2,
    input  wire [AW-1:0]       src3,  input wire [TGT_BITS-1:0] tgt3,  input wire [LYR_BITS-1:0] lyr3,  output reg [31:0] weight3,
    input  wire [AW-1:0]       src4,  input wire [TGT_BITS-1:0] tgt4,  input wire [LYR_BITS-1:0] lyr4,  output reg [31:0] weight4,
    input  wire [AW-1:0]       src5,  input wire [TGT_BITS-1:0] tgt5,  input wire [LYR_BITS-1:0] lyr5,  output reg [31:0] weight5,
    input  wire [AW-1:0]       src6,  input wire [TGT_BITS-1:0] tgt6,  input wire [LYR_BITS-1:0] lyr6,  output reg [31:0] weight6,
    input  wire [AW-1:0]       src7,  input wire [TGT_BITS-1:0] tgt7,  input wire [LYR_BITS-1:0] lyr7,  output reg [31:0] weight7,
    input  wire [AW-1:0]       src8,  input wire [TGT_BITS-1:0] tgt8,  input wire [LYR_BITS-1:0] lyr8,  output reg [31:0] weight8,
    input  wire [AW-1:0]       src9,  input wire [TGT_BITS-1:0] tgt9,  input wire [LYR_BITS-1:0] lyr9,  output reg [31:0] weight9,
    input  wire [AW-1:0]      src10,  input wire [TGT_BITS-1:0] tgt10, input wire [LYR_BITS-1:0] lyr10, output reg [31:0] weight10,
    input  wire [AW-1:0]      src11,  input wire [TGT_BITS-1:0] tgt11, input wire [LYR_BITS-1:0] lyr11, output reg [31:0] weight11,
    input  wire [AW-1:0]      src12,  input wire [TGT_BITS-1:0] tgt12, input wire [LYR_BITS-1:0] lyr12, output reg [31:0] weight12,
    input  wire [AW-1:0]      src13,  input wire [TGT_BITS-1:0] tgt13, input wire [LYR_BITS-1:0] lyr13, output reg [31:0] weight13,
    input  wire [AW-1:0]      src14,  input wire [TGT_BITS-1:0] tgt14, input wire [LYR_BITS-1:0] lyr14, output reg [31:0] weight14,
    input  wire [AW-1:0]      src15,  input wire [TGT_BITS-1:0] tgt15, input wire [LYR_BITS-1:0] lyr15, output reg [31:0] weight15,
    input  wire [AW-1:0]      src16,  input wire [TGT_BITS-1:0] tgt16, input wire [LYR_BITS-1:0] lyr16, output reg [31:0] weight16,
    input  wire [AW-1:0]      src17,  input wire [TGT_BITS-1:0] tgt17, input wire [LYR_BITS-1:0] lyr17, output reg [31:0] weight17,
    input  wire [AW-1:0]      src18,  input wire [TGT_BITS-1:0] tgt18, input wire [LYR_BITS-1:0] lyr18, output reg [31:0] weight18,
    input  wire [AW-1:0]      src19,  input wire [TGT_BITS-1:0] tgt19, input wire [LYR_BITS-1:0] lyr19, output reg [31:0] weight19
);

    localparam DEPTH      = (1 << (AW + TGT_BITS + LYR_BITS));
    localparam STRIDE_LYR = (1 << (AW + TGT_BITS));
    localparam STRIDE_TGT = (1 << AW);

    reg [31:0] mem [0:DEPTH-1];

    integer i;
    initial begin
        // zero-fill for safety; file then overwrites present entries
        for (i=0; i<DEPTH; i=i+1) mem[i] = 32'd0;
        $readmemh("weights_all.hex", mem);
    end

    // small helper: guarded read function
    function [31:0] rd;
        input [LYR_BITS-1:0] lyr;
        input [TGT_BITS-1:0] tgt;
        input [AW-1:0]       src;
        integer idx;
        begin
            if ((^lyr === 1'bx) || (^tgt === 1'bx) || (^src === 1'bx)) begin
                rd = 32'd0;
            end else begin
                idx = (lyr * STRIDE_LYR) + (tgt * STRIDE_TGT) + src;
                if (idx >= 0 && idx < DEPTH) rd = mem[idx];
                else                          rd = 32'd0;
            end
        end
    endfunction

    // combinational reads
    always @(*) begin
        weight0  = rd(lyr0,  tgt0,  src0 );
        weight1  = rd(lyr1,  tgt1,  src1 );
        weight2  = rd(lyr2,  tgt2,  src2 );
        weight3  = rd(lyr3,  tgt3,  src3 );
        weight4  = rd(lyr4,  tgt4,  src4 );
        weight5  = rd(lyr5,  tgt5,  src5 );
        weight6  = rd(lyr6,  tgt6,  src6 );
        weight7  = rd(lyr7,  tgt7,  src7 );
        weight8  = rd(lyr8,  tgt8,  src8 );
        weight9  = rd(lyr9,  tgt9,  src9 );
        weight10 = rd(lyr10, tgt10, src10);
        weight11 = rd(lyr11, tgt11, src11);
        weight12 = rd(lyr12, tgt12, src12);
        weight13 = rd(lyr13, tgt13, src13);
        weight14 = rd(lyr14, tgt14, src14);
        weight15 = rd(lyr15, tgt15, src15);
        weight16 = rd(lyr16, tgt16, src16);
        weight17 = rd(lyr17, tgt17, src17);
        weight18 = rd(lyr18, tgt18, src18);
        weight19 = rd(lyr19, tgt19, src19);
    end
endmodule
