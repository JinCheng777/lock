`timescale 1ns / 1ps
// 输出的是低电平有效
module decoder_3_8(
               a,
               b,
               c,
               out
        );
      input a;
      input b;
      input c;
      output reg [7:0]out;
      
      always@(*)begin//等价于always({a,b,c})a是高位，c是低位
         case({a,b,c})
              3'b000:out=8'b1111_1110;             
              3'b001:out=8'b1111_1101;
              3'b010:out=8'b1111_1011; 
              3'b011:out=8'b1111_0111; 
              3'b100:out=8'b1110_1111; 
              3'b101:out=8'b1101_1111; 
              3'b110:out=8'b1011_1111; 
              3'b111:out=8'b0111_1111; 
         endcase
      end
      
endmodule