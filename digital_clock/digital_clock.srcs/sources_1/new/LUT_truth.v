`timescale 1ns / 1ps
module LUT_truth(
    rst_n,
    num,
    out
    );
    // 共阳极型
    // 因为没有用到所有字母,所以只用5位即可
    input [4:0]num ;
    input rst_n;
    output reg [7:0]out ;
    //从低位到高位为a-g,第8位为小数点
    always@(num or rst_n)
    begin
        if (! rst_n)
        out = 8'h00;    //复位时全亮,相当于检查灯管有无故障
        else begin
        case(num)
        5'h0 : out = 8'hc0 ;    //e.g.11000000,点亮abcdef,对应数字的形状为'0'
        5'h1 : out = 8'hf9 ;
        5'h2 : out = 8'ha4 ;
        5'h3 : out = 8'hb0 ;
        5'h4 : out = 8'h99 ;
        5'h5 : out = 8'h92 ;
        5'h6 : out = 8'h82 ;
        5'h7 : out = 8'hf8 ;
        5'h8 : out = 8'h80 ;
        5'h9 : out = 8'h90 ;
        5'ha : out = 8'h88 ;
        5'hb : out = 8'h83 ;
        5'hc : out = 8'hc6 ;
        5'hd : out = 8'ha1 ;
        5'he : out = 8'h86 ;
        5'hf : out = 8'h8e ;    // 10001110,点亮aefg
        5'd16 : out = 8'b11000010 ; //g: acdef 01000011 11000010
        5'd17 : out = 8'b10001001; //h: bcefg 10010001 10001001
        5'd20 : out = 8'h8a;// k: afegc a-g:01010001 g-a:10001010
        5'd21 : out = 8'hc7;// L:fed 11100011 11000111
        5'd23 : out = 8'b11001000;//n:egc 11010101 10101011 abcef 00010011 11001000
        5'd25 : out = 8'ha3;// o:cdeg 11000101 10100011
        5'd27 : out = 8'hce;//r afe 01110011 11001110
        5'd30 : out = 8'hc1;//U : bcdef 10000011 11000001
        5'd22 : out = 8'h0;
        default : out = 8'hff;  //全不亮
        endcase
        end
    end
    // unlock : 波形循环顺次出现:8a,c6,a3,a7,ab,c1,ff,ff
    // lock : 波形循环顺次出现:8a,c6,a3,a7,ff,ff,ff,ff
endmodule
