module example(
    input [31:0] a, // 32-bit input
    input [31:0] b, // 32-bit input
    output [31:0] result // 32-bit output
);

assign result = a - b; // Directly add the inputs

endmodule

module test_add(
);
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] result;
    example ex(a,b,result);

    initial begin
        a = 32'd100;
        b = 32'd200;
    end

    initial
    begin
        $monitor($time, "  a: %d\n                     b: %d\n                     result: %d\n                     ",a,b,result);
    end

endmodule