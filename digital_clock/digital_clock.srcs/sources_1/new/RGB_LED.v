`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 19:16:55
// Design Name: 
// Module Name: RGB_LED
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


module RGB_LED(
    input clk,
    input [2:0]RGB_switch,    //高电平有效,从最高位到最低为分别控制红绿蓝灯
    input rst_n,
    output reg[2:0]out_RGB
    );
    always @(posedge clk or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                out_RGB = 3'b111;                                                           
            else
                out_RGB = RGB_switch;                               
        end                                          
endmodule
