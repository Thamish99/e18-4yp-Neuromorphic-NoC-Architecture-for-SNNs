
module network_interface_sequential (
    input wire CLK,            //clock
    input wire clear,          //clear to start timestep
    
    //1 bit wire to get spike information from each of the adders
    input wire spike0, spike1,spike2,spike3, spike4,spike5,spike6,spike7,spike8,spike9,
                spike10,spike11,spike12,spike13,spike14,spike15,spike16,spike17,spike18,spike19,

    //output source addresses to fifo macs
    output reg[11:0] spike_out_source0, spike_out_source1, spike_out_source2, spike_out_source3,    
    spike_out_source4, spike_out_source5,    spike_out_source6,    spike_out_source7,    
    spike_out_source8,    spike_out_source9,    spike_out_source10, spike_out_source11, 
    spike_out_source12,    spike_out_source13, spike_out_source14,    spike_out_source15,    
    spike_out_source16,  spike_out_source17,    spike_out_source18, spike_out_source19
);
    
    parameter  number_of_neurons=20;                            //number of neurons
    reg[11:0] downstream_connections[0:(number_of_neurons*3)];  //support 3 connections per neuron
    reg[4:0] connection_pointer[0:number_of_neurons];           //point to connection starting point according to CSR
    reg spike_register[0:number_of_neurons-1];                  //to register neurons
    reg stage1, stage2, stage3;                                 //stage 1 for collecting spikes, stage 2 for lookup
                                                                        //stage 3 for distribution to the FIFOs
    reg[11:0] spike_out_source[0:number_of_neurons];           //save the spike out information

    reg [1:0] phase;                    //routing done in phases
    reg [3:0] phase_counter;            //to count the phases
    
    //define phases
    parameter PHASE_COLLECT     = 2'b01;                            
    parameter PHASE_LOOKUP      = 2'b10;
    parameter PHASE_DISTRIBUTE  = 2'b11;

    parameter CYCLES_COLLECT    = 20;            //# of clock cycles to collect spikes
    parameter CYCLES_LOOKUP     = 1+60;            //# of clock cycles to lookup 
    parameter CYCLES_DISTRIBUTE = 4;            //number of clock cycles to distribute

    //look up distribution phase registers
    reg [3:0] current_neuron;           
    reg [7:0] conn_index;
    reg [1:0] look_up_state;

    //states in look up and distribution stage
    parameter look_up_IDLE      = 2'd0;
    parameter look_up_CHECK     = 2'd1;
    parameter look_up_SEND      = 2'd2;
    parameter look_up_ADVANCE   = 2'd3;

    //initialize Network Interface
    initial begin

        //CSR
        connection_pointer[0] = 5'd0; 
        connection_pointer[1] = 5'd3;
        connection_pointer[2] = 5'd5;
        connection_pointer[3] = 5'd8;
        connection_pointer[4] = 5'd10;
        connection_pointer[5] = 5'd12;
        connection_pointer[6] = 5'd14;
        connection_pointer[7] = 5'd15;
        connection_pointer[8] = 5'd17;
        connection_pointer[9] = 5'd18;
        connection_pointer[10] = 5'd19;

        //initialize downstream connections
        downstream_connections[0] = 12'b000000000011;
        downstream_connections[1] = 12'b000000000101;
        downstream_connections[2] = 12'b000000000111;
        downstream_connections[3] = 12'b000000000100;
        downstream_connections[4] = 12'b000000000110;
        downstream_connections[5] = 12'b000000000100;
        downstream_connections[6] = 12'b000000000101;
        downstream_connections[7] = 12'b000000000110;
        downstream_connections[8] = 12'b000000001000;
        downstream_connections[9] = 12'b000000001001;
        downstream_connections[10] = 12'b000000001000;
        downstream_connections[11] = 12'b000000001001;
        downstream_connections[12] = 12'b000000001000;
        downstream_connections[13] = 12'b000000001001;
        downstream_connections[14] = 12'b000000001001;
        downstream_connections[15] = 12'b000000001000;
        downstream_connections[16] = 12'b000000001001;
        downstream_connections[17] = 12'b111111111011;
        downstream_connections[18] = 12'b111111111100;
        downstream_connections[19] = 12'd0;

        //spike register to 0
        spike_register[0] = 1'b0;
        spike_register[1] = 1'b0;
        spike_register[2] = 1'b0;
        spike_register[3] = 1'b0;
        spike_register[4] = 1'b0;
        spike_register[5] = 1'b0;
        spike_register[6] = 1'b0;
        spike_register[7] = 1'b0;
        spike_register[8] = 1'b0;
        spike_register[9] = 1'b0;
        spike_register[10] = 1'b0;
        spike_register[11] = 1'b0;
        spike_register[12] = 1'b0;
        spike_register[13] = 1'b0;
        spike_register[14] = 1'b0;
        spike_register[15] = 1'b0;
        spike_register[16] = 1'b0;
        spike_register[17] = 1'b0;
        spike_register[18] = 1'b0;
        spike_register[19] = 1'b0;

        //define phases
        

    end


    always @(posedge CLK) begin
        
        case(phase)

            //collect incoming spikes
            PHASE_COLLECT: begin

                //count the clock cycles
                if (phase_counter == CYCLES_COLLECT - 1) begin
                    phase <= PHASE_LOOKUP;
                    phase_counter <= 0;
                end else begin
                    phase_counter <= phase_counter + 1;

                    //do something in this phase

                    //register incoming spikes
                    spike_register[0] = spike0;
                    spike_register[1] = spike1;
                    spike_register[2] = spike2;
                    spike_register[3] = spike3;
                    spike_register[4] = spike4;
                    spike_register[5] = spike5;
                    spike_register[6] = spike6;
                    spike_register[7] = spike7;
                    spike_register[8] = spike8;
                    spike_register[9] = spike9;
                    spike_register[10] = spike10;
                    spike_register[11] = spike11;
                    spike_register[12] = spike12;
                    spike_register[13] = spike13;
                    spike_register[14] = spike14;
                    spike_register[15] = spike15;
                    spike_register[16] = spike16;
                    spike_register[17] = spike17;
                    spike_register[18] = spike18;
                    spike_register[19] = spike19;                    
                end
            end 
            
          /*  PHASE_LOOKUP: begin
                //count the clock cycles
                if (phase_counter == CYCLES_LOOKUP - 1) begin
                    phase <= CYCLES_DISTRIBUTE;
                    phase_counter <= 0;
                end else begin
                    phase_counter <= phase_counter + 1;

                //do something in this phase
                case (look_up_state)

                    //idle stage to move on to check
                    look_up_IDLE: begin
                        current_neuron <= 0;
                        look_up_state <= look_up_CHECK;
                    end 

                    //check if spikes are registered. If so get the connections. Move to send state.
                    // if no spikes move to advance
                    look_up_CHECK: begin
                        if (spike_register[current_neuron]) begin
                            conn_index <= connection_pointer[current_neuron];
                            look_up_state <= look_up_SEND;
                        end else begin
                            look_up_state <= look_up_ADVANCE;
                        end
                    end

                    //send the spikes to the downstream connections.
                    look_up_SEND: begin
                        if (conn_index < connection_pointer[current_neuron + 1]) begin
                            spike_out_source[current_neuron] <= {downstream_connections[conn_index]};
                            conn_index <= conn_index + 1;
                        end else begin
                            spike_out_source[current_neuron] <= 12'd0;
                            spike_register[current_neuron] <= 0;
                            look_up_state <= look_up_ADVANCE;
                        end
                    end       

                    //move on to the next neuron. If all are done this is done.
                    look_up_ADVANCE: begin
                        if (current_neuron < number_of_neurons-1) begin
                            current_neuron <= current_neuron + 1;
                            look_up_state <= look_up_CHECK;
                        end else begin
                            look_up_state <= look_up_IDLE;
                        end
                    end                    
                endcase                    
                end
            end

            CYCLES_DISTRIBUTE: begin
                
                //count the clock cycles
                if (phase_counter == CYCLES_DISTRIBUTE - 1) begin
                    phase <= PHASE_COLLECT;
                    phase_counter <= 0;
                end else begin
                    phase_counter <= phase_counter + 1;
                end
            end 
            */
        endcase
    end


endmodule






