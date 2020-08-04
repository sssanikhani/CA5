`timescale 1ns/1ns
module MainMemory(input rst, input [14:0] address, 
                   output [31:0] MainMemoryToCache0,
                   output [31:0] MainMemoryToCache1, 
                   output [31:0] MainMemoryToCache2, 
                   output [31:0] MainMemoryToCache3);
    reg [31:0] main [0:32767];
    reg [31:0] Sample [0:31];
    
    integer i;
    integer j;
  
    initial begin
        $readmemh ("Sample.data", Sample);
        for (i = 0; i < 1024; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                main[i * 32 + j] = Sample[j];
            end
        end
    end

    always @(posedge rst) begin
        for(i = 0; i < 1024; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                main[i * 32 + j] = Sample[j];
            end
        end
    end        
      
    assign MainMemoryToCache0 = main[{address[14:2],2'b00}];
    assign MainMemoryToCache1 = main[{address[14:2],2'b01}];
    assign MainMemoryToCache2 = main[{address[14:2],2'b10}];
    assign MainMemoryToCache3 = main[{address[14:2],2'b11}];

endmodule
