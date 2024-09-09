`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/30 11:15:53
// Design Name: 
// Module Name: debounce
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


module debounce#(
    parameter CNT_20ms = 24'd2_000_000//20ms counter value
)
(
    input key_in,
    input clk, //100mHz
    input rst_n,     // valid when low 
    output reg key_out
    );


//20ms counter
	reg [23:0] cnt_delay;
    reg cnt_full;
	// always @ (posedge key_in)begin
    //     cnt_delay <= 24'd0;
    // end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_delay <= 24'd0;
		else begin
			if(cnt_delay <= CNT_20ms)
                    cnt_delay <= cnt_delay + 24'd1;
            else
                cnt_delay <= 24'd0;
        end
	end
    always @(cnt_delay) begin
        if (cnt_delay == CNT_20ms) key_out <= key_in;
        else key_out <= key_in;
    end
    // always @ (posedge cnt_full)begin
    //     key_out = key_in;
    // end
endmodule
