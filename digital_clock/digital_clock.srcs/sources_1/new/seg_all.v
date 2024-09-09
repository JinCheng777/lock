`timescale 1ns / 1ps
module seg_all #(
    parameter one_dis_t = 25'd1_000_00
)
(//八个数码管显示
    clk,
    rst_n,
    disp_num_all,
    dg_tube,
    tube_part
    );
    
    input clk ;
    input rst_n ;
    input [39:0]disp_num_all ;      // 8个要显示的字符,一个字符占5位(包含数字和字母)
    output [7:0]dg_tube ;
    output [7:0]tube_part ;
    
    wire [7:0] seg_index ;
    // parameter one_dis_t = 25'd1_000_00 ;//每个晶体管显示时间(计数),parameter定义的是局部参数，所以只在本模块中有效
    
    reg [25:0]counter1 ;
    reg [2:0] counter2 ;
    
    always @ ( posedge clk or negedge rst_n )//分频,分出来的一个周期是一个数码管显示的时间
    begin
        if (! rst_n )
        counter1 <= 25'd0 ;
        else if ( (one_dis_t-1) <= counter1 )
        counter1 <= 25'd0 ;
        else
        counter1 <= counter1 +25'b1 ;
    end
    
    always @ ( posedge clk or negedge rst_n )//循环,在8个数码管之间循环选择
    begin
        if (! rst_n )
        counter2 <= 3'd0 ;
        else if ( (one_dis_t-1) <= counter1 ) 
        counter2 <= counter2 +1'b1 ;        //计到7再加1就自动回到0
    end
    
    wire [4:0]disp_num_one ;
    
    //3-8译码器 控制哪个数码管显示
    decoder_3_8 tube_select(//控制,注意:被选中的应该输出低电平
               .a(counter2[2] ),        //a为高位
               .b(counter2[1]),
               .c(counter2[0]),
               .out(seg_index)        //输出被选的数码管编号
        );
    assign dg_tube = seg_index & {8{rst_n}};     //当rst_n=0时复位,全亮
    //需要一个八选一选通器,对应哪个数码管显示什么内容
    LED_mux8  tube_display(//选通,输入
    .sel(counter2),         //如counter2=000,则mux8给出第0个数码管应该显示的内容(4bit)
    .data(disp_num_all),
    .out(disp_num_one)
    );
    
    //真值表对应显示数字
    LUT_truth translator(//把待显示的内容转换为a-g哪几段LED亮
    .rst_n(rst_n),
    .num(disp_num_one),
    .out(tube_part)     //8bit,包括小数点
    );
endmodule
