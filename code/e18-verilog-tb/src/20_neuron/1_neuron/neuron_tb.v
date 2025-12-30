module neuron_tb();

    //variables
    reg clk;
    reg[11:0] source_address;
    wire spike;

    neuron n1(.clk(clk),
                .source_address(source_address),
                .spike(spike));

    initial begin
        $dumpfile("neuron_tb.vcd");
        $dumpvars(0,neuron_tb);
    end

    //testbench
    initial begin
        clk=0;
        source_address = 12'd0;     
    end

    initial begin
        #21 source_address = 12'd7;
    end

    initial #500 $finish;

    always #5 clk = ~clk;

    always @(posedge clk) source_address = 12'd0;


endmodule