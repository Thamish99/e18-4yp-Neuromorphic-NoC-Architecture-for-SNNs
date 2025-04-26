// MAC unit can process 4 input spikes together
// 4 spike inputs  
// 4 weights corresponding to the synapse

/*  Floating point addition
    Moving through the next four connections ?*/
`timescale 1ns/1ns
// `include "Addition_Subtraction.v"
 

module mac0(
    
    input wire clk,                             //input clock
	 //input wire set,										//set signal for initialisation
    //input wire[11:0] neuron_address,            //neuron address
    input wire[11:0] source_address,            //source address of 12 bits
    //input wire[160-1:0] weights_array,            //weights array used during intialization 32x5=160 bits
    //input wire[60-1:0] source_addresses_array,          //corresponding source address array used during initialization 12x5=60 bits
    //input wire clear,                       //signal to signify the end of the timestep
	 //input wire [31:0]SET_Count,
    output reg[31:0] mult_output               //output of 32 bits to the adder
    );             

	 //reg [11:0] source_address;
    parameter number_of_connections = 5;
    parameter number_of_address_bits = 12;
    parameter number_of_units = 10;
    parameter weights_array_width = 32 * number_of_connections;

    integer i;                      //iterate through for the sources addresses
    integer index;                  //get array index of the connection
    reg[number_of_connections-1:0] incomingspikes;   //note incoming spikes
    reg[number_of_connections-1:0] spikes;            //received stored spikes
    reg[31:0] weights [0:number_of_connections-1];    //array to store 5 weights
    reg[11:0] source_addresses [0:number_of_connections-1];    //array to store corresponding 5 source addresses
    reg break;
    reg[31:0] accumulated_weight;   //get the accumulated weight
    reg[31:0] considered_weight;    //weight to be added
    wire[31:0] added_weight;         //weight
    wire exception;                 //addition exception
    integer topBorder;
    integer lowerBorder;


    //get source address and edit the source address
    always @(source_address) begin
        case (source_address)
            source_addresses[0]: incomingspikes[0:0]=1'b1;
            source_addresses[1]: incomingspikes[1:1]=1'b1;
            source_addresses[2]: incomingspikes[2:2]=1'b1;
            source_addresses[3]: incomingspikes[3:3]=1'b1;
            source_addresses[4]: incomingspikes[4:4]=1'b1;            
            default: incomingspikes=5'b00000;
        endcase
    end

    //when pos edge send out weight accoridng to spike inputs
    always @(posedge clk) begin

        spikes[4:4] = incomingspikes[4:4];
        spikes[3:3] = incomingspikes[3:3];
        spikes[2:2] = incomingspikes[2:2];
        spikes[1:1] = incomingspikes[1:1];
        spikes[0:0] = incomingspikes[0:0];

        accumulated_weight = 32'd0;     //set accumulated value to 0
        considered_weight = 32'd0;      //weight addition is zero

        case (spikes)
            5'b00000: mult_output = 32'h00000000;
            5'b00001: mult_output = 32'h4290B333;
            5'b00010: mult_output = 32'h41975C29;
            5'b00011: mult_output = 32'h42B68A3D;
            5'b00100: mult_output = 32'h42470A3D;
            5'b00101: mult_output = 32'h42F43851;
            5'b00110: mult_output = 32'h42895C29;
            5'b00111: mult_output = 32'h430D07AF;
            5'b01000: mult_output = 32'h00000000;
            5'b01001: mult_output = 32'h4290B333;
            5'b01010: mult_output = 32'h41975C29;
            5'b01011: mult_output = 32'h42B68A3D;
            5'b01100: mult_output = 32'h42470A3D;
            5'b01101: mult_output = 32'h42F43851;
            5'b01110: mult_output = 32'h42895C29;
            5'b01111: mult_output = 32'h430D07AF;
            5'b10000: mult_output = 32'h42AE3851;
            5'b10001: mult_output = 32'h431F75C3;
            5'b10010: mult_output = 32'h42D40F5D;
            5'b10011: mult_output = 32'h43326147;
            5'b10100: mult_output = 32'h4308DEB9;
            5'b10101: mult_output = 32'h43513851;
            5'b10110: mult_output = 32'h431BCA3D;
            5'b10111: mult_output = 32'h436423D7;
            5'b11000: mult_output = 32'h42AE3851;
            5'b11001: mult_output = 32'h431F75C3;
            5'b11010: mult_output = 32'h42D40F5D;
            5'b11011: mult_output = 32'h43326147;
            5'b11100: mult_output = 32'h4308DEB9;
            5'b11101: mult_output = 32'h43513851;
            5'b11110: mult_output = 32'h431BCA3D;
            5'b11111: mult_output = 32'h436423D7;
            default: mult_output = 32'h00000000;
        endcase  

        //spikes 0
        spikes[4:4] = 1'b0; 
        spikes[3:3] = 1'b0;
        spikes[2:2] = 1'b0;
        spikes[1:1] = 1'b0;
        spikes[0:0] = 1'b0;      
    end
	

    //initial
    initial begin
        incomingspikes[4:4] = 1'b0;
        incomingspikes[3:3] = 1'b0;
        incomingspikes[2:2] = 1'b0;
        incomingspikes[1:1] = 1'b0;
        incomingspikes[0:0] = 1'b0;

        source_addresses[4] = 12'd7;
        source_addresses[3] = 12'd6;
        source_addresses[2] = 12'd5;
        source_addresses[1] = 12'd4;
        source_addresses[0] = 12'd11;
    end
endmodule