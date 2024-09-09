`timescale 1ns / 1ps
module LED_mux8(
    sel,
    data,
    out
    );
    
    input [2:0]sel ;
    input [39:0]data ;
    output reg [4:0]out ;   //out输出的是某一个数码管a-g是否点亮的信息
    
    always@(*)
    begin
    case(sel)

        3'b000 : out = data[4:0] ;
        3'b001 : out = data[9:5] ;
        3'b010 : out = data[14:10] ;
        3'b011 : out = data[19:15] ;
        3'b100 : out = data[24:20] ;
        3'b101 : out = data[29:25] ;
        3'b110 : out = data[34:30] ;
        3'b111 : out = data[39:35] ;

    endcase
    end
endmodule
