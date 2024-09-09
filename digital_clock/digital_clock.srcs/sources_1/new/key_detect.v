`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 16:07:23
// Design Name: 
// Module Name: key_detect
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


module key_detect #(
    parameter cnt4debouncer = 24'd2_000_000
)
(
    input key_in,
    input clk,
    input rst_n,
    output rise,
    output fall,
    output smooth
    );
    
    debounce #(
        .CNT_20ms(cnt4debouncer)
    )
    debouncer
    (
    .key_in(key_in),
    .clk(clk), 
    .rst_n(rst_n),     // valid when low 
    .key_out(smooth)
    );
    // defparam debouncer.CNT_20ms = cnt4debouncer;
    edge_detect edge_detecter(
    .clk_100m(clk),
    .rst_n(rst_n),
    .signal(smooth),
    .pos_edge(rise),
    .neg_edge(fall)
    );
    
endmodule
