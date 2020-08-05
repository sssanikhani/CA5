`timescale 1ns/1ns
module TB();
    reg [14:0] address;
    reg rst, clk;
    wire [31:0] MMToCache [0:3];
    wire [14:0] MMAddress;
    wire Hit;
    wire [31:0] cacheData;

    Cache C(clk, rst, address, MMToCache[0], MMToCache[1], MMToCache[2], MMToCache[3], MMAddress, cacheData, Hit);
    MainMemory M(rst, MMAddress, MMToCache[0], MMToCache[1], MMToCache[2], MMToCache[3]);
    
    initial begin
        #10 rst = 0; #10 rst = 1; #10 rst = 0; #10 clk = 0;
        repeat (8200) begin
            #20 clk = 1; #20 clk = 0;
        end
    end
    initial begin
        #42 address = 1024;
        repeat (8191) begin
            #40 address = address + 1; 
        end
        #50;
    end

endmodule
