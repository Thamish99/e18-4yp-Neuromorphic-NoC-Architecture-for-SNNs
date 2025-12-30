module set_clear (
    input wire CLK,
    output reg clear,
    output reg set
);

	 reg [31:0] CLK_count;
	 reg [31:0] SET_Count;
	 
	  //timestep is 4 clockcycles
    always @(posedge CLK) begin
			SET_Count = SET_Count + 1;
			if(SET_Count == 2) begin
					set = 1'b1;
			end  
		  
			if (SET_Count === 4) begin
				set = 1'b0;
			end
	 
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
     initial begin
        CLK_count = 1'b0;
        SET_Count = 1'b0;
     end
    
endmodule