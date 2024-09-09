`timescale 1ns / 1ps

module LED_16breath #(
    parameter min_s = 32'd999,       //最小计数器cnt_min:0-100,必须与num的范围保持一样,num表征亮度等级 32'd99
parameter T_10ms = 32'd999_999 //T_10ms表征每过多久亮度变化一级 32'd99_999
)
(
    input rst_n,
    input clk_100m,
    output reg [15:0]out_LED
    );

reg[31:0] cnt_1s;
reg[31:0] cnt_10ms;
reg[31:0] cnt_min;
reg [31:0] num;
reg[0:0] flag;     


//parameter T_1s = 32'd4999_9999; //T_1s一定得是T_10ms的min_s倍
parameter T_1s = (T_10ms + 32'd1) * (min_s+32'd1) -1;
////////////////
always@(posedge clk_100m or negedge rst_n)//cmp
if (!rst_n)
    num<=0; 
else if(num>min_s)
    num<=0;
else if(cnt_10ms==T_10ms)
    num=num+1;


always@(posedge clk_100m or negedge rst_n)//最小计数器
if (!rst_n)
    cnt_min<=0;
else if(cnt_min==min_s)
    cnt_min<=0;
else 
    cnt_min<=cnt_min+32'd1;

always@(posedge clk_100m or negedge rst_n)//10ms占空比
if (!rst_n)
    cnt_10ms<=0;
else if(cnt_10ms==T_10ms)
    cnt_10ms<=0;
else 
    cnt_10ms<=cnt_10ms+32'd1;
    
always@(posedge clk_100m or negedge rst_n)//1s
if (!rst_n)
    begin
    cnt_1s<=0;
    flag<=0;
    end
else if(cnt_1s==T_1s)
begin
    cnt_1s<=0;
    flag<=~flag;
end
else 
    cnt_1s<=cnt_1s+32'd1;
    
always@(posedge clk_100m or negedge rst_n)//用最小计数器的值与期望占空比进行比较，进行输出
if (!rst_n)
out_LED<=0;
else if(flag==1&&cnt_min>num)
out_LED<=16'b1111_1111_1111_1111;
else if(flag==0&&cnt_min<num)
out_LED<=16'b1111_1111_1111_1111;
else
out_LED<=16'b0;             
endmodule
