`timescale 1ns/1ns
module Cache(input clk, rst, input [14:0] address, 
                input [31:0] MMToCache0, MMToCache1, MMToCache2, MMToCache3,
                output [14:0] addressToMM, output reg [31:0] data, output reg Hit);
    reg [0:0] Valid [0:1023];
    reg [2:0] Tag [0:1023];
    reg [31:0] main [0:1023][0:3];
    integer i;
    
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            main[i][0] = 32'b0;
            main[i][1] = 32'b0;
            main[i][2] = 32'b0;
            main[i][3] = 32'b0;
            Tag[i] = 3'b0;
            Valid[i] = 1'b0;
        end
        data = 32'b0;
        Hit = 1'b0;
    end

    always @(address, posedge clk, posedge rst) begin
        if (rst) begin
            for (i = 0; i < 1024; i = i + 1) begin
                main[i][0] = 32'b0;
                main[i][1] = 32'b0;
                main[i][2] = 32'b0;
                main[i][3] = 32'b0;
                Tag[i] = 3'b0;
                Valid[i] = 1'b0;
            end
            data = 32'b0;
            Hit = 1'b0;
        end
        else if (clk) begin
            if(~Hit) begin
                Tag[address[11:2]] = address[14:12];
                Valid[address[11:2]] = 1;
                #2
                main [address[11:2]][0] = MMToCache0;
                main [address[11:2]][1] = MMToCache1;
                main [address[11:2]][2] = MMToCache2;
                main [address[11:2]][3] = MMToCache3;
                data = main [address[11:2]][address[1:0]];
            end
            if(Valid[address[11:2]] == 1 && Tag[address[11:2]] == address[14:12]) begin
                data = main[address[11:2]][address[1:0]];
                Hit = 1;
            end
            else begin
                Hit = 0;
            end
        end
        else begin
            if(Valid[address[11:2]] == 1 && Tag[address[11:2]] == address[14:12]) begin
                data = main[address[11:2]][address[1:0]];
                Hit = 1;
            end
            else begin
                Hit = 0;
            end
        end
    end

    assign addressToMM = Hit ? addressToMM : address;
endmodule


