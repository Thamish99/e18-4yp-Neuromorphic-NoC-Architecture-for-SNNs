module timestep_controller_single (
    input  wire CLK,
    input  wire rst_n,
    input  wire done_i,
    output reg  clear_o
);
    reg fired;

    always @(posedge CLK) begin
        if (!rst_n) begin
            clear_o <= 1'b0;
            fired   <= 1'b0;
        end else begin
            clear_o <= 1'b0;

            // When accelerator is busy, allow next clear later
            if (!done_i) fired <= 1'b0;

            // Emit exactly one clear when done is high
            if (done_i && !fired) begin
                clear_o <= 1'b1;
                fired   <= 1'b1;
            end
        end
    end
endmodule
