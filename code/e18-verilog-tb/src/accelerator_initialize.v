`timescale 1ns/100ps
// `include "potential_decay.v"
`include "mac0.v"
`include "mac1.v"
`include "mac2.v"
`include "mac3.v"
`include "mac4.v"
`include "mac5.v"
`include "mac6.v"
`include "mac7.v"
`include "mac8.v"
`include "mac9.v"
`include "mac10.v"
`include "mac11.v"
`include "mac12.v"
`include "mac13.v"
`include "mac14.v"
`include "mac15.v"
`include "mac16.v"
`include "mac17.v"
`include "mac18.v"
`include "mac19.v"

`include "potential_decay_0.v"
`include "potential_decay_1.v"
`include "potential_decay_2.v"
`include "potential_decay_3.v"
`include "potential_decay_4.v"
`include "potential_decay_5.v"
`include "potential_decay_6.v"
`include "potential_decay_7.v"
`include "potential_decay_8.v"
`include "potential_decay_9.v"
`include "potential_decay_10.v"
`include "potential_decay_11.v"
`include "potential_decay_12.v"
`include "potential_decay_13.v"
`include "potential_decay_14.v"
`include "potential_decay_15.v"
`include "potential_decay_16.v"
`include "potential_decay_17.v"
`include "potential_decay_18.v"
`include "potential_decay_19.v"

`include "potential_adder_0.v"
`include "potential_adder_1.v"
`include "potential_adder_2.v"
`include "potential_adder_3.v"
`include "potential_adder_4.v"
`include "potential_adder_5.v"
`include "potential_adder_6.v"
`include "potential_adder_7.v"
`include "potential_adder_8.v"
`include "potential_adder_9.v"
`include "potential_adder_10.v"
`include "potential_adder_11.v"
`include "potential_adder_12.v"
`include "potential_adder_13.v"
`include "potential_adder_14.v"
`include "potential_adder_15.v"
`include "potential_adder_16.v"
`include "potential_adder_17.v"
`include "potential_adder_18.v"
`include "potential_adder_19.v"


// `include "Addition_Subtraction.v"
// `include "Multiplication.v"
// `include "potential_adder.v"
// `include "network_interface.v"

module accelerator_initialize;

    parameter number_of_neurons=20;                        //initiailize number of neurons
    reg CLK;                                                //clock
    reg[3:0] decay_rate;                                    //define decay rate
    reg[3:0] CLK_count;                                     //counter for clocks

    wire[11:0] source_addresses[0:number_of_neurons-1];          //write her simulate spike packets by sending source addresses
    reg[159:0] weights_arrays[0:number_of_neurons-1];           //initialize store weights of the connections
    reg[59:0] source_addresses_arrays[0:number_of_neurons-1];   //initialize connection by writing source addresses to the accumulators
    reg[11:0] neuron_addresses[0:number_of_neurons-1];          //initialize with neuron addresses
    reg[31:0] membrane_potential[0:number_of_neurons-1];        //initialize membrane potential values
    reg[31:0] v_threshold[0:number_of_neurons-1];               //threshold values
    reg[359:0] downstream_connections_initialization;    //input to initialize the dowanstream connections
    reg[119:0] neuron_addresses_initialization;                //input to initialize the neruon addresses
    reg[54:0] connection_pointer_initialization;               //input to initialize the connection pointers
    reg[11:0] spike_origin;                               //to store the nueron address from the arrived packet
    reg[11:0] spike_destination;                               //to store source address from the arrived packet
    reg[1:0] model;
    reg[31:0]a, b, c, d, u_initialize;      //for izhikevich model
    wire[31:0] results_mac[0:number_of_neurons-1];                 //store results from the mac
    wire[31:0] results_potential_decay[0:number_of_neurons-1];     //store results of potential decay
    wire[31:0] final_potential[0:number_of_neurons-1];             //potential form the potential adder
    wire spike[0:number_of_neurons-1];                              //spike signifier from potential decay
    wire[23:0] packet;                          //packet containing neuron address and sources address
    wire set, clear;
    //generate 10 potential decay units
    genvar i;
    // generate
    //     for(i=0; i<10; i=i+1) begin
    //         potential_decay pd(
    //             .CLK(CLK),
    //             .clear(clear),
    //             .model(model),
    //             .neuron_address_initialization(neuron_addresses[i]),
    //             .decay_rate(decay_rate),
    //             .membrane_potential_initialization(membrane_potential[i]),
    //             .output_potential_decay(results_potential_decay[i]),
    //             .new_potential(final_potential[i])
    //         );
    //     end
    // endgenerate

    //generate 10 accumulators
    // generate
    //     for(i=0; i<1; i=i+1) begin
    //         mac0 m(
    //             .CLK_Mac(CLK),
    //             //.neuron_address(neuron_addresses[i]),
    //             //.source_address(source_addresses[i]),
    //            // .weights_array(weights_arrays[i]),
    //             //.source_addresses_array(source_addresses_arrays[i]),
    //            // .clear(clear),
    //             .mult_output(results_mac[i])
    //         );
    //     end
    // endgenerate

    //macs
    mac0 m0(.CLK_Mac(CLK), .mult_output(results_mac[0]));
    mac1 m1(.CLK_Mac(CLK), .mult_output(results_mac[1]));
    mac2 m2(.CLK_Mac(CLK), .mult_output(results_mac[2]));
    mac3 m3(.CLK_Mac(CLK), .source_address(source_addresses[3]), .mult_output(results_mac[3]));
    mac4 m4(.CLK_Mac(CLK), .source_address(source_addresses[4]), .mult_output(results_mac[4]));
    mac5 m5(.CLK_Mac(CLK), .source_address(source_addresses[5]), .mult_output(results_mac[5]));
    mac6 m6(.CLK_Mac(CLK), .source_address(source_addresses[6]), .mult_output(results_mac[6]));
    mac7 m7(.CLK_Mac(CLK), .source_address(source_addresses[7]), .mult_output(results_mac[7]));
    mac8 m8(.CLK_Mac(CLK), .source_address(source_addresses[8]), .mult_output(results_mac[8]));
    mac9 m9(.CLK_Mac(CLK), .source_address(source_addresses[9]), .mult_output(results_mac[9]));
    mac10 m10(.CLK_Mac(CLK), .source_address(source_addresses[10]), .mult_output(results_mac[10]));
    mac11 m11(.CLK_Mac(CLK), .source_address(source_addresses[11]), .mult_output(results_mac[11]));
    mac12 m12(.CLK_Mac(CLK), .source_address(source_addresses[12]), .mult_output(results_mac[12]));
    mac13 m13(.CLK_Mac(CLK), .source_address(source_addresses[13]), .mult_output(results_mac[13]));
    mac14 m14(.CLK_Mac(CLK), .source_address(source_addresses[14]), .mult_output(results_mac[14]));
    mac15 m15(.CLK_Mac(CLK), .source_address(source_addresses[15]), .mult_output(results_mac[15]));
    mac16 m16(.CLK_Mac(CLK), .source_address(source_addresses[16]), .mult_output(results_mac[16]));
    mac17 m17(.CLK_Mac(CLK), .source_address(source_addresses[17]), .mult_output(results_mac[17]));
    mac18 m18(.CLK_Mac(CLK), .source_address(source_addresses[18]), .mult_output(results_mac[18]));
    mac19 m19(.CLK_Mac(CLK), .source_address(source_addresses[19]), .mult_output(results_mac[19]));

            
    //decays
    potential_decay_0 pd0(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[0]),.new_potential(final_potential[0]));
    potential_decay_1 pd1(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[1]),.new_potential(final_potential[1]));
    potential_decay_2 pd2(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[2]),.new_potential(final_potential[2]));
    potential_decay_3 pd3(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[3]),.new_potential(final_potential[3]));
    potential_decay_4 pd4(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[4]),.new_potential(final_potential[4]));
    potential_decay_5 pd5(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[5]),.new_potential(final_potential[5]));
    potential_decay_6 pd6(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[6]),.new_potential(final_potential[6]));
    potential_decay_7 pd7(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[7]),.new_potential(final_potential[7]));
    potential_decay_8 pd8(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[8]),.new_potential(final_potential[8]));
    potential_decay_9 pd9(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[9]),.new_potential(final_potential[9]));
    potential_decay_10 pd10(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[10]),.new_potential(final_potential[10]));
    potential_decay_11 pd11(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[11]),.new_potential(final_potential[11]));
    potential_decay_12 pd12(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[12]),.new_potential(final_potential[12]));
    potential_decay_13 pd13(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[13]),.new_potential(final_potential[13]));
    potential_decay_14 pd14(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[14]),.new_potential(final_potential[14]));
    potential_decay_15 pd15(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[15]),.new_potential(final_potential[15]));
    potential_decay_16 pd16(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[16]),.new_potential(final_potential[16]));
    potential_decay_17 pd17(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[17]),.new_potential(final_potential[17]));
    potential_decay_18 pd18(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[18]),.new_potential(final_potential[18]));
    potential_decay_19 pd19(.clear(clear), .set(set), .output_potential_decay(results_potential_decay[19]),.new_potential(final_potential[19]));

    //adders    
    potential_adder_0 pa0(.clear(clear), .set(set), .input_weight(results_mac[0]),.decayed_potential(results_potential_decay[0]),.final_potential(final_potential[0]),.spike(spike[0]));
    potential_adder_1 pa1(.clear(clear), .set(set), .input_weight(results_mac[1]),.decayed_potential(results_potential_decay[1]),.final_potential(final_potential[1]),.spike(spike[1]));
    potential_adder_2 pa2(.clear(clear), .set(set), .input_weight(results_mac[2]),.decayed_potential(results_potential_decay[2]),.final_potential(final_potential[2]),.spike(spike[2]));
    potential_adder_3 pa3(.clear(clear), .set(set), .input_weight(results_mac[3]),.decayed_potential(results_potential_decay[3]),.final_potential(final_potential[3]),.spike(spike[3]));
    potential_adder_4 pa4(.clear(clear), .set(set), .input_weight(results_mac[4]),.decayed_potential(results_potential_decay[4]),.final_potential(final_potential[4]),.spike(spike[4]));
    potential_adder_5 pa5(.clear(clear), .set(set), .input_weight(results_mac[5]),.decayed_potential(results_potential_decay[5]),.final_potential(final_potential[5]),.spike(spike[5]));
    potential_adder_6 pa6(.clear(clear), .set(set), .input_weight(results_mac[6]),.decayed_potential(results_potential_decay[6]),.final_potential(final_potential[6]),.spike(spike[6]));
    potential_adder_7 pa7(.clear(clear), .set(set), .input_weight(results_mac[7]),.decayed_potential(results_potential_decay[7]),.final_potential(final_potential[7]),.spike(spike[7]));
    potential_adder_8 pa8(.clear(clear), .set(set), .input_weight(results_mac[8]),.decayed_potential(results_potential_decay[8]),.final_potential(final_potential[8]),.spike(spike[8]));
    potential_adder_9 pa9(.clear(clear), .set(set), .input_weight(results_mac[9]),.decayed_potential(results_potential_decay[9]),.final_potential(final_potential[9]),.spike(spike[9]));
    potential_adder_10 pa10(.clear(clear), .set(set), .input_weight(results_mac[10]),.decayed_potential(results_potential_decay[0]),.final_potential(final_potential[10]),.spike(spike[10]));
    potential_adder_11 pa11(.clear(clear), .set(set), .input_weight(results_mac[11]),.decayed_potential(results_potential_decay[11]),.final_potential(final_potential[11]),.spike(spike[11]));
    potential_adder_12 pa12(.clear(clear), .set(set), .input_weight(results_mac[12]),.decayed_potential(results_potential_decay[12]),.final_potential(final_potential[12]),.spike(spike[12]));
    potential_adder_13 pa13(.clear(clear), .set(set), .input_weight(results_mac[13]),.decayed_potential(results_potential_decay[13]),.final_potential(final_potential[13]),.spike(spike[13]));
    potential_adder_14 pa14(.clear(clear), .set(set), .input_weight(results_mac[14]),.decayed_potential(results_potential_decay[14]),.final_potential(final_potential[14]),.spike(spike[14]));
    potential_adder_15 pa15(.clear(clear), .set(set), .input_weight(results_mac[15]),.decayed_potential(results_potential_decay[15]),.final_potential(final_potential[15]),.spike(spike[15]));
    potential_adder_16 pa16(.clear(clear), .set(set), .input_weight(results_mac[16]),.decayed_potential(results_potential_decay[16]),.final_potential(final_potential[16]),.spike(spike[16]));
    potential_adder_17 pa17(.clear(clear), .set(set), .input_weight(results_mac[17]),.decayed_potential(results_potential_decay[17]),.final_potential(final_potential[17]),.spike(spike[17]));
    potential_adder_18 pa18(.clear(clear), .set(set), .input_weight(results_mac[18]),.decayed_potential(results_potential_decay[18]),.final_potential(final_potential[18]),.spike(spike[18]));
    potential_adder_19 pa19(.clear(clear), .set(set), .input_weight(results_mac[19]),.decayed_potential(results_potential_decay[19]),.final_potential(final_potential[19]),.spike(spike[19]));



    set_clear st(.CLK(CLK), .clear(clear), .set(set));
    // //genrate corresponding 10 potential adders
    // generate
    //     for(i=0; i<10; i=i+1) begin
    //         potential_adder pa(
    //             .clear(clear),
    //             .v_threshold(v_threshold[i]),
    //             .input_weight(results_mac[i]),
    //             .decayed_potential(results_potential_decay[i]),
    //             .model(model),
    //             .a(a),
    //             .b(b),
    //             .c(c),
    //             .d(d),
    //             .u_initialize(u_initialize),
    //             .final_potential(final_potential[i]),
    //             .spike(spike[i])
    //         );
    //     end
    // endgenerate

    network_interface_static ni1(
        .CLK(CLK),
        .clear(clear),
        // .spikes({spike[0],spike[1],spike[2],spike[3],spike[4],spike[5],spike[6],spike[7],spike[8],spike[9]}),
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
        .spike19(spike[19]),
        .neuron_addresses_initialization(neuron_addresses_initialization),
        .connection_pointer_initialization(connection_pointer_initialization),           //input to initialize the connection pointers
        .downstream_connections_initialization(downstream_connections_initialization),    //input to initialize the dowanstream connections
        //.packet(packet)               //outgoing packet
        .spike_out_source3(source_addresses[3]),
        .spike_out_source4(source_addresses[4]),
        .spike_out_source5(source_addresses[5]),
        .spike_out_source6(source_addresses[6]),
        .spike_out_source7(source_addresses[7]),
        .spike_out_source8(source_addresses[8]),
        .spike_out_source9(source_addresses[9]),
        .spike_out_source10(source_addresses[10]),
        .spike_out_source11(source_addresses[11]),
        .spike_out_source12(source_addresses[12]),
        .spike_out_source13(source_addresses[13]),
        .spike_out_source14(source_addresses[14]),
        .spike_out_source15(source_addresses[15]),
        .spike_out_source16(source_addresses[16]),
        .spike_out_source17(source_addresses[17]),
        .spike_out_source18(source_addresses[18]),
        .spike_out_source19(source_addresses[19])
    );

    // // Observe the timing on gtkwave
    // initial
    // begin
    //     $dumpfile("testbench.vcd");
    //     $dumpvars(0, testbench);
    // end

    // // Print the outputs when ever the inputs change
    initial
    begin
        $monitor($time, "  Neuron_address: %b\n                     Membrane Potential: %b\n                     Decay Rate: %d\n                     After Potential Decay: %b\n                     Source_address: %b\n                     MAC result: %b\n                     Threshold: %b\n                     Output Potential: %b\n                     Spiked:%b", neuron_addresses[0], membrane_potential[0], decay_rate, results_potential_decay[0], source_addresses[0], results_mac[0],v_threshold[0],final_potential[0], spike[0]);
    end

    // Observe the timing on gtkwave
    initial begin
        $dumpfile("accelerator_wavedata.vcd");
        $dumpvars(0,accelerator_initialize);
    end

    // //assign inputs
    initial begin
        CLK = 1'b0;
        CLK_count = 0;
        //clear = 1'b0;
        decay_rate = 4'b0010;
        model = 2'b00;

        //neuron addresses
        neuron_addresses[0] = 12'd0;
        neuron_addresses[1] = 12'd1;
        neuron_addresses[2] = 12'd2;
        neuron_addresses[3] = 12'd3;
        neuron_addresses[4] = 12'd4;
        neuron_addresses[5] = 12'd5;
        neuron_addresses[6] = 12'd6;
        neuron_addresses[7] = 12'd7;
        neuron_addresses[8] = 12'd8;
        neuron_addresses[9] = 12'd9;

        //for spike handling module
        neuron_addresses_initialization = {neuron_addresses[0],neuron_addresses[1],neuron_addresses[2],
        neuron_addresses[3],neuron_addresses[4],neuron_addresses[5],neuron_addresses[6],neuron_addresses[7],
        neuron_addresses[8],neuron_addresses[9]};

        //CSR
        connection_pointer_initialization = {5'd0, 5'd3, 5'd5, 5'd8, 5'd10, 5'd12, 5'd14, 5'd15, 5'd17, 5'd18, 5'd19};

        downstream_connections_initialization = {12'b000000000011, 12'b000000000101, 12'b000000000111, 
        12'b000000000100, 12'b000000000110,
        12'b000000000100, 12'b000000000101, 12'b000000000110,
        12'b000000001000, 12'b000000001001,
        12'b000000001000, 12'b000000001001,
        12'b000000001000, 12'b000000001001,
        12'b000000001001,
        12'b000000001000, 12'b000000001001,
        12'b111111111011,
        12'b111111111100,
        132'd0};


        //initial membrane potential values
        membrane_potential[0] = 32'h41deb852;
        membrane_potential[1] = 32'h42806b85;
        membrane_potential[2] = 32'h40b75c29;
        membrane_potential[3] = 32'h4228b852;
        membrane_potential[4] = 32'h42aeb852;
        membrane_potential[5] = 32'h429deb85;
        membrane_potential[6] = 32'h4165eb85;
        membrane_potential[7] = 32'h4212147b;
        membrane_potential[8] = 32'h428e2e14;
        membrane_potential[9] = 32'h411a147b;

        //send source addresses array first
        source_addresses_arrays[0] = {12'b001111111000, 12'b111111111111, 12'b111111111111, 12'b111111111111, 12'b111111111111};
        source_addresses_arrays[1] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[2] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[3] = {12'd0, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[4] = {12'd1, 12'd2, 12'd5, 12'd0, 12'd0};
        source_addresses_arrays[5] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[6] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[7] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[8] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};
        source_addresses_arrays[9] = {12'd3, 12'd4, 12'd5, 12'd6, 12'd7};

        //assign the weights
        weights_arrays[0] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[1] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[2] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[3] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[4] = {32'h423f47ae, 32'h4109999a, 32'h0, 32'h0, 32'h0};
        weights_arrays[5] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[6] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[7] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[8] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};
        weights_arrays[9] = {32'h4290b333, 32'h41975c29, 32'h42470a3d, 32'h0, 32'h42ae3852};

        //threshold values
        v_threshold[0] = 32'h42200000;
        v_threshold[1] = 32'h4237851f;
        v_threshold[2] = 32'h4048f5c3;
        v_threshold[3] = 32'h42910000;
        v_threshold[4] = 32'h43480000;
        v_threshold[5] = 32'h426b28f6;
        v_threshold[6] = 32'h42200000;
        v_threshold[7] = 32'h43480000;
        v_threshold[8] = 32'h4215ae14;
        v_threshold[9] = 32'h4287c7ae;

        a = 32'h4287c7ae;
        b = 32'h4287c7ae;
        c = 32'h4287c7ae;
        d = 32'h4287c7ae;
        u_initialize = 32'h4287c7ae;
        
        #40
        //source_addresses[0] = 12'b001111111000;
        // source_addresses[4] = 12'd1;

        // #4
        // source_addresses[6] = 12'd4; 
        // source_addresses[4] = 12'd2; 

        // #4
        // source_addresses[6] = 12'd5;

        // #4
        // source_addresses[4] = 12'd7; 

        #1000
        $finish;   
    end

    //when packets arrive from the potential adder send the source address to the relevant mac unit 
    // always @(packet) begin
    //     spike_origin = packet[23:12];               // From where the spike came
    //     spike_destination = packet[11:0];           // To where it should be sent 

    //     source_addresses[spike_destination] = spike_origin;      // Trigger the wire of the relevant accumulator
    // end

    //invert clock every 4 seconds
    always
        #4 CLK = ~CLK;

    //timestep is 4 clockcycles
    // always @(posedge CLK) begin

    //     if(CLK_count==3) begin
    //         CLK_count=0;
    //         clear = 1'b1;
    //     end else begin
    //         CLK_count = CLK_count+1;
    //     end

    //     if(CLK_count==1) begin
    //         clear = 1'b0;
    //     end
    // end

    

endmodule