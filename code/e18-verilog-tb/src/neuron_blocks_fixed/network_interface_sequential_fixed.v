`timescale 1ns/1ps
module ni_aer_flat
#(
    parameter integer N        = 1024,    // neurons
    parameter integer AW       = 10,      // log2(N)
    parameter integer EAW      = 20,      // log2(MAXE)
    parameter        IDX_FILE  = "conn_index.hex",   // N+1 lines
    parameter        TGT_FILE  = "conn_targets.hex", // M lines (low AW bits used)
    parameter        W_FILE    = "conn_weights.hex"  // M lines (IEEE-754)
)
(
    input  wire               CLK,
    input  wire               rst_n,
    input  wire               clear_i,         // pulse: begin new timestep
    input  wire [N-1:0]       spikes_in,       // spikes from neurons (prev step)
    input  wire [N-1:0]       ext_spikes,      // external injection (ORed at clear)
    output reg                bus_valid,
    output reg  [AW-1:0]      bus_dst_id,
    output reg  [31:0]        bus_weight,
    output reg                done
);
    localparam integer MAXE = (1 << EAW);

    // CSR tables
    reg [31:0] index_mem [0:N];           // N+1 entries (0..N)
    reg [31:0] tgt_mem   [0:MAXE-1];
    reg [31:0] w_mem     [0:MAXE-1];

    integer i, j;
    initial begin
        // zero-fill to avoid X if files are shorter than arrays
        for (i=0; i<=N; i=i+1) index_mem[i] = 32'd0;
        for (i=0; i<MAXE; i=i+1) begin
            tgt_mem[i] = 32'd0;
            w_mem[i]   = 32'd0;
        end
        $readmemh(IDX_FILE, index_mem);
        $readmemh(TGT_FILE, tgt_mem);
        $readmemh(W_FILE,   w_mem);
    end

    // State
    reg [N-1:0] pending;                  // sources to drain this step
    reg [AW-1:0] curr_src;
    reg          streaming;
    reg [31:0]   ptr, ptr_end;

    // Robust capture of external spikes around clear
    reg [N-1:0] ext_d1, ext_d2;

    // Priority-pick next pending source (0..N-1)
    reg          found_next;
    reg [AW-1:0] next_src;
    always @(*) begin
        found_next = 1'b0;
        next_src   = {AW{1'b0}};
        for (j=0; j<N; j=j+1) begin
            if (!found_next && pending[j]) begin
                found_next = 1'b1;
                next_src   = j[AW-1:0];
            end
        end
    end

    // Synchronize/remember external spikes (2-cycle window)
    always @(posedge CLK) begin
        if (!rst_n) begin
            ext_d1 <= {N{1'b0}};
            ext_d2 <= {N{1'b0}};
        end else begin
            ext_d1 <= ext_spikes;
            ext_d2 <= ext_d1;
        end
    end

    // Core FSM
    always @(posedge CLK) begin
        if (!rst_n) begin
            pending   <= {N{1'b0}};
            curr_src  <= {AW{1'b0}};
            streaming <= 1'b0;
            ptr       <= 32'd0;
            ptr_end   <= 32'd0;
            bus_valid <= 1'b0;
            bus_dst_id<= {AW{1'b0}};
            bus_weight<= 32'd0;
            done      <= 1'b1;           // idle after reset
        end else if (clear_i) begin
            // Latch spikes at timestep start; include 1-cycle history of externals
            // This makes seeding robust to TB timing around clear.
            pending   <= (spikes_in | ext_spikes | ext_d1);
            curr_src  <= {AW{1'b0}};
            streaming <= 1'b0;
            ptr       <= 32'd0;
            ptr_end   <= 32'd0;
            bus_valid <= 1'b0;
            bus_dst_id<= {AW{1'b0}};
            bus_weight<= 32'd0;
            done      <= ~|(spikes_in | ext_spikes | ext_d1);
        end else begin
            bus_valid <= 1'b0;

            if (!streaming) begin
                if (|pending) begin
                    if (found_next) begin
                        curr_src  <= next_src;
                        ptr       <= index_mem[next_src];
                        ptr_end   <= index_mem[next_src + 1]; // safe: index_mem is 0..N
                        streaming <= 1'b1;
                        done      <= 1'b0;
                    end else begin
                        done <= 1'b1;
                    end
                end else begin
                    done <= 1'b1;
                end
            end else begin
                // Stream one edge per cycle
                if (ptr < ptr_end) begin
                    bus_valid <= 1'b1;
                    bus_dst_id<= tgt_mem[ptr][AW-1:0];
                    bus_weight<= w_mem[ptr];
                    ptr       <= ptr + 1;
                end else begin
                    // Finished this source; clear its bit and pick another
                    streaming         <= 1'b0;
                    pending[curr_src] <= 1'b0;
                end
            end
        end
    end
endmodule
