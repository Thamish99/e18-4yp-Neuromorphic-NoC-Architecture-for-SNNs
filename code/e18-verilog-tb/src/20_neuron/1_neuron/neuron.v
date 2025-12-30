`include "mac0.v"
`include "potential_decay_0.v"
`include "potential_adder_0.v"

module neuron(input wire clk, input wire[11:0] source_address, output wire spike);

    wire[31:0] mult_output;
    wire[31:0] output_potential_decay;
    wire[31:0] final_potential;

    //mac
    mac0 m0(.clk(clk), 
            .source_address(source_address),
            .mult_output(mult_output));

    //decay
    potential_decay_0 pd0(.clk(clk),
                            .output_potential_decay(output_potential_decay),
                            .new_potential(final_potential));

    //adder
    potential_adder_0 pa0( .input_weight(mult_output),
                            .decayed_potential(output_potential_decay),
                            .final_potential(final_potential),
                            .spike(spike));

endmodule