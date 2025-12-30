`timescale 1ns/1ps
// snn_flat_tb.v  (flat, no layers, Verilog-2001 compatible)
// Build example:
//  iverilog -g2001 -o simv \
//    accelerator_initialize_seq_fixed.v ni_aer_flat.v timestep_controller_single.v neuron_tile_float.v \
//    mac_float.v potential_adder_float.v potential_decay_float.v Addition_Subtraction.v && vvp simv

module snn_flat_tb;

// ---------- Parameters (Verilog-2001) ----------
parameter AW  = 10;                // 1024 neurons
parameter N   = (1<<AW);
parameter EAW = 16;                // enough bits for total edges M
parameter T   = 10;                // timesteps per image (lines in mask .hex)
parameter PULSE_W = 2;             // hold ext_spikes for this many cycles after clear_ev

// ---------- Clock / reset ----------
reg CLK, rst_n;
initial begin
  CLK = 1'b0;
  forever #5 CLK = ~CLK;           // 100 MHz
end

// ---------- DUT I/O ----------
reg  [N-1:0] ext_spikes;           // external spike injection (ORed inside NI)
wire         bus_valid;
wire [AW-1:0] bus_dst_id;
wire [31:0]  bus_weight;
wire [N-1:0] spikes;
wire         ni_done, clear_ev;

// Optional membrane tap array; comment out if not needed or not supported by your tools
wire [31:0]  v_mem [0:N-1];

// ---------- Network Interface ----------
ni_aer_flat #(
  .N(N), .AW(AW), .EAW(EAW),
  .IDX_FILE("conn_index.hex"),
  .TGT_FILE("conn_targets.hex"),
  .W_FILE  ("conn_weights.hex")
) NI (
  .CLK(CLK), .rst_n(rst_n), .clear_i(clear_ev),
  .spikes_in(spikes),
  .ext_spikes(ext_spikes),
  .bus_valid(bus_valid),
  .bus_dst_id(bus_dst_id),
  .bus_weight(bus_weight),
  .done(ni_done)
);

// ---------- Clear/timestep generator ----------
timestep_controller_single TS (
  .CLK(CLK), .rst_n(rst_n), .done_i(ni_done), .clear_o(clear_ev)
);

// ---------- Neuron array ----------
genvar i;
generate
  for (i=0; i<N; i=i+1) begin : NEUR
    neuron_tile_float #(.ID(i), .AW(AW)) NT (
      .CLK(CLK), .rst_n(rst_n), .clear(clear_ev),
      .bus_valid(bus_valid), .bus_dst_id(bus_dst_id), .bus_weight(bus_weight),
      .spike(spikes[i]), .v_mem(v_mem[i])
    );
  end
endgenerate

// ---------- Power-on init ----------
initial begin
  // VCD
  $dumpfile("snn_flat.vcd");
  $dumpvars(0, snn_flat_tb);

  // Reset & zero inputs
  rst_n      = 1'b0;
  ext_spikes = {N{1'b0}};
  repeat (2) @(posedge CLK);
  rst_n = 1'b1;
end

// ---------- Helpful prints ----------
always @(posedge CLK) begin
  if (bus_valid)
    $display("%0t BUS: dst=%0d weight=%h", $time, bus_dst_id, bus_weight);
  if (clear_ev)
    $display("%0t CLEAR: spikes_in[15:0]=%h ext[15:0]=%h", $time, spikes[15:0], ext_spikes[15:0]);
end

// =====================================================
// MNIST rate-coded stimulus (Verilog-2001 safe)
// Drives ext_spikes for PULSE_W cycles after clear_ev
// =====================================================

// T entries, each is an N-bit mask (for N=1024 -> 256 hex chars per line)
reg [N-1:0] stim [0:T-1];
integer tstep;

// Verilog-2001 path string as wide reg
reg [1023:0] STIM_FILE;

// Simple pulse counter (no $clog2)
reg [7:0] pulse_cnt;

// Load one mask file: pass at runtime with +STIM="path/to/stim_masks_0000.hex"
initial begin
  if (!$value$plusargs("STIM=%s", STIM_FILE))
    STIM_FILE = "stim/stim_masks_0000.hex";
  $display("Loading stimulus: %0s", STIM_FILE);
  $readmemh(STIM_FILE, stim);
end

// Drive ext_spikes on each clear_ev; hold for PULSE_W cycles
always @(posedge CLK) begin
  if (!rst_n) begin
    tstep      <= 0;
    pulse_cnt  <= 0;
    ext_spikes <= {N{1'b0}};
  end else begin
    if (clear_ev) begin
      ext_spikes <= stim[tstep];
      if (PULSE_W > 0) pulse_cnt <= PULSE_W - 1;
      else             pulse_cnt <= 0;

      if (tstep == T-1) tstep <= 0;
      else              tstep <= tstep + 1;
    end else if (pulse_cnt != 0) begin
      pulse_cnt  <= pulse_cnt - 1;
      ext_spikes <= ext_spikes;           // keep asserted
    end else begin
      ext_spikes <= {N{1'b0}};            // deassert between ticks
    end
  end
end

always @(posedge CLK)
  if (clear_ev)
    $display("OUT SPIKES = %b", spikes[1023:1014]);


endmodule
