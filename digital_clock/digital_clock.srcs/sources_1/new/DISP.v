`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/31 17:36:36
// Design Name: 
// Module Name: DISP
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

module DISP #(
    parameter u_seg_all_one_dis_t = 25'd1_000_00,
    parameter u_LED_16_cnt_max4_blink = 32'd500_000_00,
    parameter u_LED_16_min_s4breath = 32'd99,
    parameter u_LED_16_T_10ms4breath = 32'd499999
)
(
    input clk,
    input rst_n,
    input [39:0]seg_disp_num,
    input [1:0]LED16_switch,
    input [2:0]RGB_LED_switch_1,
    input [2:0]RGB_LED_switch_2,
    output wire [7:0]seg_select,
    output wire [7:0]tube_part,
    output wire [15:0]out_LED16,
    output wire [2:0]out_RGB_LED_1,
    output wire [2:0]out_RGB_LED_2
    );
    seg_all #(
        .one_dis_t(u_seg_all_one_dis_t)
    )
    u_seg_all(
        .clk(clk),
        .rst_n(rst_n),
        .disp_num_all(seg_disp_num),
        .dg_tube(seg_select),
        .tube_part(tube_part)
    );
    LED_16 u_LED_16(
        .mode(LED16_switch),
        .rst_n(rst_n),
        .clk_100m(clk),
        .out_LED(out_LED16)
    );
    RGB_LED u_RGB_LED_1(
        .clk(clk),
        .RGB_switch(RGB_LED_switch_1),
        .rst_n(rst_n),
        .out_RGB(out_RGB_LED_1)
    );
    RGB_LED u_RGB_LED_2(
        .clk(clk),
        .RGB_switch(RGB_LED_switch_2),
        .rst_n(rst_n),
        .out_RGB(out_RGB_LED_2)
    );
endmodule
