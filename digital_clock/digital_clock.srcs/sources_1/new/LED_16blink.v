`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 21:14:01
// Design Name: 
// Module Name: LED_16blink
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED_16blink #(
        parameter integer cnt_max = 32'd500_000_00   //每过cnt个时钟周期,灯状态变化一次,如500_000对应5ms(时钟100mHz,其周期为10ns) to :500_000_00.若改成0.5则是50ns变一次状态
)
(
    input rst_n,
    input clk_100m,
    output reg [15:0]out_LED
    );
    reg [31:0] cnt;
    reg flag;
    always @(posedge clk_100m or negedge rst_n) begin
        if(!rst_n)begin                               
                cnt <= 0;
                flag <= 0;
        end
            else if(cnt == cnt_max)begin
                cnt <= 0;
                flag = ~flag;
            end                       
            else                    
                cnt <= cnt + 32'd1;
    end



    always @(posedge clk_100m or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                out_LED <= 16'b0;
            else                    
                out_LED <= {16{flag}};
        end                                          
endmodule
