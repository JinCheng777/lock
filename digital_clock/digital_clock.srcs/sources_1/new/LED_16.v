`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 20:48:17
// Design Name: 
// Module Name: LED_16
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


module LED_16 #(
    parameter cnt_max4_blink = 32'd500_000_00,
    parameter min_s4breath = 32'd99,
    parameter T_10ms4breath = 32'd499999
)
(
    input [1:0]mode,
    input rst_n,
    input clk_100m,
    output reg [15:0]out_LED
    );
parameter all_close = 2'b00;   //all close
parameter all_on = 2'b01;   //all on
parameter blink = 2'b10;   //blink
parameter breath = 2'b11;   //breath

// 向低层次传入的参数
// parameter cnt_max4_blink = 32'd500_000_00;
// parameter min_s4breath = 32'd99;
// parameter T_10ms4breath = 32'd499999;
// parameter T_1s4breath = 32'd4999_9999;

wire [15:0] out_LED_blink;
wire [15:0] out_LED_breath ;
LED_16blink #(
    .cnt_max(cnt_max4_blink)
)
u_LED_16blink(
    .rst_n(rst_n),
    .clk_100m(clk_100m),
    .out_LED(out_LED_blink)
    );
// defparam u_LED_16blink.cnt_max = cnt_max4_blink;
LED_16breath #(
    .min_s(min_s4breath),
    .T_10ms(T_10ms4breath)
)
u_LED_16breath(
    .rst_n(rst_n),
    .clk_100m(clk_100m),
    .out_LED(out_LED_breath)
);
// defparam u_LED_16breath.min_s=min_s4breath;
// defparam u_LED_16breath.T_10ms=T_10ms4breath;
// defparam u_LED_16breath.T_1s=T_1s4breath;

    always @(posedge clk_100m or negedge rst_n)           
        begin                                        
            if(!rst_n)                               
                out_LED<=16'hffff;
                //复位时全亮(高电平驱动)                                                  
            else
            case(mode)
                all_close   :   out_LED=16'b0;
                all_on  :   out_LED=16'hffff;
                blink   :   out_LED = out_LED_blink;
                breath  : out_LED = out_LED_breath;
                endcase  
                        
        end                                          
endmodule
