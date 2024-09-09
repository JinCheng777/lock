`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 20:34:55
// Design Name: 
// Module Name: tb_top_module
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


module tb_top_module();
reg clk;
reg rst_n;
reg [4:0]dir_btn_raw=0;
reg admin_btn_raw=0;
reg set_pwd_btn_raw=0;
wire [15:0]led16;
wire [2:0]RGB_led_1;
wire [2:0]RGB_led_2;
wire [7:0]seg_sel;
wire [7:0]tube_sel;

always #5 clk=~clk; //100MHz时钟
parameter t_25ms = 25_000_000;
// parameter t_25ms = 25_000_000;
parameter t_10s = 400*t_25ms;
parameter t_20s = 2*t_10s;

//按下按钮task
task    press_mid;
begin
    #t_25ms dir_btn_raw[0]=1;
    #t_25ms dir_btn_raw[0]=0;
end
endtask
task    press_up;
begin
    #t_25ms dir_btn_raw[2]=1;
    #t_25ms dir_btn_raw[2]=0;
end
endtask
task    press_down;
begin
    #t_25ms dir_btn_raw[1]=1;
    #t_25ms dir_btn_raw[1]=0;
end
endtask
task    press_left;
begin
    #t_25ms dir_btn_raw[4]=1;
    #t_25ms dir_btn_raw[4]=0;
end
endtask
task    press_right;
begin
    #t_25ms dir_btn_raw[3]=1;
    #t_25ms dir_btn_raw[3]=0;
end
endtask
task    press_set_pwd;
begin
    #t_25ms set_pwd_btn_raw=1;
    #t_25ms set_pwd_btn_raw=0;
end
endtask
task    press_admin_btn;
begin
    #t_25ms admin_btn_raw=1;
    #t_25ms admin_btn_raw=0;
end
endtask
task input_pwd9999;
begin
    press_mid;
    press_down;
    press_right;

    press_down;
    press_right;

    press_down;
    press_right;

    press_down;
    press_right;

    press_mid;
end
endtask


initial begin
    clk=0;
    rst_n = 0;
    #500 rst_n =1;
    dir_btn_raw=5'b00000;
    admin_btn_raw=0;
    set_pwd_btn_raw=0;//s_wait
    //此时数码管应显示LOCK,LED应全部熄灭

    //测试自动休眠
    press_mid;
    press_right;
    #t_10s       //3us,应自动返回

    //输入密码0000，设置密码用缺省密码0000，正确
    press_mid;
    press_right;

    press_up;
    press_down;
    press_right;

    press_right;
    press_left;
    press_left;
    press_left;

    press_right;
    press_right;
    press_right;
    press_right;

    press_mid;

    #t_20s   //6us,应该自动返回

    //接下来设置密码1928
    press_set_pwd;
    press_up;
    press_right;

    press_down;
    press_right;

    press_up;
    press_up;
    press_right;

    press_down;
    press_down;
    press_right;

    press_mid;
    //接下来第1次输错密码
    input_pwd9999;
    #t_25ms
    // $display("1st error! pwd_set=%h,pwd_try=%h,err_cnt=%d",u_top_module.pwd_set,u_top_module.pwd_try,u_top_module.err_cnt);

    press_mid;//应该要再按一次中间按钮，进入输入密码状态
    //接下来第2次输错密码
    input_pwd9999;
    #t_25ms
    // $display("2st error! pwd_set=%h,pwd_try=%h,err_cnt=%d",u_top_module.pwd_set,u_top_module.pwd_try,u_top_module.err_cnt);    

    press_mid;//应该要再按一次中间按钮，进入输入密码状态
    //接下来第3次输错密码
    input_pwd9999;
    #t_25ms
    // $display("3st error! pwd_set=%h,pwd_try=%h,err_cnt=%d",u_top_module.pwd_set,u_top_module.pwd_try,u_top_module.err_cnt);

    #t_20s   //6us,但不应该自动返回
    press_admin_btn;    //消除报警
    #t_25ms;
    // $display("clear warning! pwd_set=%h,pwd_try=%h,err_cnt=%d",u_top_module.pwd_set,u_top_module.pwd_try,u_top_module.err_cnt);




end

// initial begin
//     $monitor("Middle key change to value %d at the time %t.", dir_btn_raw[0], $time);
//     $monitor("left key change to value %d at the time %t.", dir_btn_raw[4], $time);
// end
Top_module #(
    .u_silent10_time_cnt (100),
    .u_silent10_clk10ms_max(0),
    .u_silent10_clk20ms_max(1),
    .u_silent20_time_cnt(200),
    .u_silent20_clk10ms_max(0),
    .u_silent20_clk20ms_max(1),
    .u_key_left_cnt4debouncer(5),
    .u_key_right_cnt4debouncer(5),
    .u_key_up_cnt4debouncer(5),
    .u_key_down_cnt4debouncer(5),
    .u_key_mid_cnt4debouncer(5),
    .u_admin_btn_cnt4debouncer(5),
    .u_set_pwd_btn_cnt4debouncer(5),
    .u_display_u_seg_all_one_dis_t(10),
    .u_display_u_LED_16_cnt_max4_blink(0.5),
    .u_display_u_LED_16_min_s4breath(9),
    .u_display_u_LED_16_T_10ms4breath(9)
)u_top_module 
(
    .clk(clk),
    .rst_n(rst_n),
    .dir_btn_raw(dir_btn_raw),  
    .admin_btn_raw(admin_btn_raw), 
    .set_pwd_btn_raw(set_pwd_btn_raw), 
    .led16(led16),
    .RGB_led_1(RGB_led_1),
    .RGB_led_2(RGB_led_2),
    .seg_sel(seg_sel),
    .tube_sel(tube_sel)
);
// defparam u_top_module.u_silent10.time_cnt=100;//等待时间4000ns
// defparam u_top_module.u_silent10.clk10ms_max=0;//20ns
// defparam u_top_module.u_silent10.clk20ms_max=1;//40ns
// defparam u_top_module.u_silent20.time_cnt=200;//等待时间4000ns
// defparam u_top_module.u_silent20.clk10ms_max=0;//20ns
// defparam u_top_module.u_silent20.clk20ms_max=1;//40ns
// defparam u_top_module.u_key_left.cnt4debouncer = 5;
// defparam u_top_module.u_key_right.cnt4debouncer = 5;
// defparam u_top_module.u_key_up.cnt4debouncer = 5;
// defparam u_top_module.u_key_down.cnt4debouncer = 5;
// defparam u_top_module.u_key_mid.cnt4debouncer = 5;
// defparam u_top_module.u_admin_btn.cnt4debouncer = 5;
// defparam u_top_module.u_set_pwd_btn.cnt4debouncer = 5;
// defparam u_top_module.u_display.u_seg_all.one_dis_t=10;
// defparam u_top_module.u_display.u_LED_16.cnt_max4_blink=0.5;     //闪烁参数:50ns变一次状态
// defparam u_top_module.u_display.u_LED_16.min_s4breath=9;         //呼吸灯级数
// defparam u_top_module.u_display.u_LED_16.T_10ms4breath=9;        //呼吸灯每级持续时间.上述2个参数使呼吸灯周期为2*10^2 ns

endmodule
