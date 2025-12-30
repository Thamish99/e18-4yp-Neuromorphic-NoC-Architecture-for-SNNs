module ni_seq_tb ();
    
    reg CLK;                                                //clock
    reg clear;                                              //clear to start timestep
    reg spike[0:19];

    network_interface_sequential ni_seq(
        .CLK(CLK),
        .clear(clear),
        .spike0(spike[0]),
        .spike1(spike[1]),
        .spike2(spike[2]),
        .spike3(spike[3]),
        .spike4(spike[4]),
        .spike5(spike[5]),
        .spike6(spike[6]),
        .spike7(spike[7]),
        .spike8(spike[8]),
        .spike9(spike[9]),
        .spike10(spike[10]),
        .spike11(spike[11]),
        .spike12(spike[12]),
        .spike13(spike[13]),
        .spike14(spike[14]),
        .spike15(spike[15]),
        .spike16(spike[16]),
        .spike17(spike[17]),
        .spike18(spike[18]),
        .spike19(spike[19]));

    // Observe the timing on gtkwave
    initial
    begin
        $dumpfile("ni_seq_tb.vcd");
        $dumpvars(0, ni_seq_tb);
    end

    always #4 CLK = ~CLK;

    //timestep is 4 clockcycles
    always @(posedge CLK) begin

        if(CLK_count==3) begin
            CLK_count=0;
            clear = 1'b1;
        end else begin
            CLK_count = CLK_count+1;
        end

        if(CLK_count==1) begin
            clear = 1'b0;
        end

    end
endmodule 