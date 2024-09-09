`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 15:02:00
// Design Name: 
// Module Name: silent10s_detect
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


module silent10s_detect #(
    parameter time_cnt=1000,
    parameter clk10ms_max=500000,
    parameter clk20ms_max=1000000
)
(clk,rst_n,dir_btn,admin_btn,set_pwd_btn,silent_10s);
input clk;//100MHz时钟 10ns
input rst_n;
input [4:0]dir_btn;
input admin_btn;
input set_pwd_btn;
output reg silent_10s=0;
reg active=0;
reg [9:0]counter=0;
reg clk20ms=0;
reg clk10ms=0;
reg [19:0]div_clk=0;
reg [19:0]div_clk2=0;
reg pre_rst_n=1;
reg jud_rst_n;
reg [4:0]pre_dir_btn=0;
reg [4:0]jud_dir_btn;
reg pre_admin_btn=0;
reg jud_admin_btn;
reg pre_set_pwd_btn=0;
reg jud_set_pwd_btn;


always @(posedge clk)
begin

    div_clk<=div_clk+1; 
    if(div_clk>=clk20ms_max)
    begin
    div_clk<=0;
    clk20ms<=~clk20ms;
    end
end
always @(posedge clk)
begin

    div_clk2<=div_clk2+1; 
    if(div_clk2>=clk10ms_max)
    begin
    div_clk2<=0;
    clk10ms<=~clk10ms;
    end
end
always @(posedge clk10ms or negedge rst_n)
begin
    if( ~rst_n)
    begin
        silent_10s<=0;
        counter<=0;
    end
   
    else if(active==1)
    begin
        counter<=0;
        silent_10s<=0;
    end

    else if(active==0)
    begin
    counter<=counter+1;
    if(counter>(time_cnt-1))
    begin
    if(counter==time_cnt)
    begin
        silent_10s<=1;
    end
    else if(counter==(time_cnt+1))
    begin
        counter<=0;
        silent_10s<=0;
    end
    end
    end
end
always @(posedge clk20ms)
begin
    jud_admin_btn<=pre_admin_btn^admin_btn;
    jud_dir_btn<=pre_dir_btn^dir_btn;
    jud_rst_n<=pre_rst_n^rst_n;
    jud_set_pwd_btn<=pre_set_pwd_btn^set_pwd_btn;
    if(jud_admin_btn!=0||jud_dir_btn!=0||jud_rst_n!=0||jud_set_pwd_btn!=0)
    begin
    active<=1;
    end
    else
    begin
    active<=0;
    end
    pre_admin_btn<=admin_btn;
    pre_dir_btn<=dir_btn;
    pre_rst_n<=rst_n;
    pre_set_pwd_btn<=set_pwd_btn;
end
endmodule
