`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 14:47:23
// Design Name: 
// Module Name: edge_detect
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


module edge_detect(
    input clk_100m,
    input rst_n,
    input signal,
    output pos_edge,
    output neg_edge
    );
    reg signal_r;
    always @ (posedge clk_100m or negedge rst_n)begin
        if(!rst_n) 
            signal_r <= 1'b0;
        else
            signal_r <= signal;
    end
    assign neg_edge = signal_r & (~signal) & (rst_n);
    assign pos_edge = (~signal_r) & signal & (rst_n);
    // 可能有问题:rst_n第一次变高的时候pos_edge 也跟着变高,这合理吗?
endmodule
