`timescale 1ns / 1ps
/*
verilog中的端口具有三种传输方向：input、output、和inout，所有的端口均默认为wire类型；
模块描述时，input端口只能为线网形，output端口可以为线网/reg，inout端口只能为线网形；
模块调用时（实例化模块时对应端口的信号），连接模块input端口的信号可以为线网/reg形，连接模块output端口的信号只能为线网，连接模块inout端口的信号也只能为线网形；
*/
module Top_module 
// #(
//     parameter u_silent10_time_cnt =1000,
//     parameter u_silent10_clk10ms_max=500000,
//     parameter u_silent10_clk20ms_max=1000000,
//     parameter u_silent20_time_cnt=2000,
//     parameter u_silent20_clk10ms_max=500000,
//     parameter u_silent20_clk20ms_max=1000000,
//     parameter u_key_left_cnt4debouncer=24'd2_000_000,
//     parameter u_key_right_cnt4debouncer=24'd2_000_000,
//     parameter u_key_up_cnt4debouncer=24'd2_000_000,
//     parameter u_key_down_cnt4debouncer=24'd2_000_000,
//     parameter u_key_mid_cnt4debouncer=24'd2_000_000,
//     parameter u_admin_btn_cnt4debouncer=24'd2_000_000,
//     parameter u_set_pwd_btn_cnt4debouncer=24'd2_000_000,
//     parameter u_display_u_seg_all_one_dis_t=25'd1_000_00,
//     parameter u_display_u_LED_16_cnt_max4_blink=32'd500_000_00,
//     parameter u_display_u_LED_16_min_s4breath=32'd999,
//     parameter u_display_u_LED_16_T_10ms4breath=32'd99999999
// )
(
    input clk,
    input rst_n,
    input [4:0]dir_btn_raw,  // 5个弹簧按键,从低到高为左 右 上 下 中
    input admin_btn_raw,    // 管理员专用的拨码开关,用于停止报警
    input set_pwd_btn_raw,   // 用于开始设置密码的拨码开关
    output wire [15:0]led16,
    output wire [2:0]RGB_led_1,
    output wire [2:0]RGB_led_2,
    output wire [7:0]seg_sel,
    output wire [7:0]tube_sel
);
// defparam u_top_module.u_silent10.time_cnt=100;//等待时间4000ns
wire [4:0]dir_btn ;
wire [4:0]dir_btn_fall;
wire admin_btn;
wire admin_btn_fall;
wire set_pwd_btn;
wire set_pwd_btn_fall;

// 按键相关
reg [3:0]current_state = 0;
reg [3:0]next_state;

// 密码判断相关
reg [1:0] err_cnt = 0;
reg [15:0] pwd_set = 16'b0 ;        // 初始密码设置为0000

reg pwd_opr_mode = 0;                     

// 定义数码管数字别名
    parameter seg_0 = 5'd0;
    parameter seg_1 = 5'd1;
    parameter seg_2 = 5'd2;
    parameter seg_3 = 5'd3;
    parameter seg_4 = 5'd4;
    parameter seg_5 = 5'd5;
    parameter seg_6 = 5'd6;
    parameter seg_7 = 5'd7;
    parameter seg_8 = 5'd8;
    parameter seg_9 = 5'd9;
    parameter seg_a = 5'ha;
    parameter seg_b = 5'hb;
    parameter seg_c = 5'hc;
    parameter seg_d = 5'hd;
    parameter seg_e = 5'he;
    parameter seg_f = 5'hf;
    parameter seg_g = 5'd16;
    parameter seg_h = 5'd17;
    parameter seg_k = 5'd20;
    parameter seg_l = 5'd21;
    parameter seg_n = 5'd23;
    parameter seg_o = 5'd25;
    parameter seg_r = 5'd27;
    parameter seg_u = 5'd30;
    parameter seg_null = 5'd31;
    parameter seg_all = 5'd22;
// 显示相关
    reg [39:0]seg_disp_num ={8{seg_null}};
    reg [1:0]LED16_switch = 0;
    reg [2:0]RGB_LED_switch_1 = 0;
    reg [2:0]RGB_LED_switch_2 = 0;

// 命名状态参数
    parameter s_wait = 4'b0000;
    parameter s_change = 4'b0001;
    parameter s_pwd_set_0b = 4'b0110;
    parameter s_pwd_set_1b = 4'b0111;
    parameter s_pwd_set_2b = 4'b1000;
    parameter s_pwd_set_3b = 4'b1001;
    parameter s_pwd_set_4b = 4'b1010;
    parameter s_unlock = 4'b1011;
    parameter s_err_no_warn = 4'b1100;
    parameter s_warn = 4'b1101;
// 满足时为1,不满足时为0
    wire c_1_num_in ;
    wire c_pwd_correct;
    wire c_silent_10s;
    wire c_silent_20s;
always @(posedge clk) begin
end
// 其他参数
    parameter pwd_check = 1'b0;     // 用于密码提交器的mode
    parameter pwd_reconfig = 1'b1 ;
wire [4:0]dir_rise ;
key_detect u_key_left(
    .key_in(dir_btn_raw[4]),
    .clk(clk),
    .rst_n(rst_n),
    .rise(dir_rise[4]),
    .smooth(dir_btn[4])
);
key_detect u_key_right(
    .key_in(dir_btn_raw[3]),
    .clk(clk),
    .rst_n(rst_n),
    .rise(dir_rise[3]),
    .smooth(dir_btn[3])
);
key_detect u_key_up(
    .key_in(dir_btn_raw[2]),
    .clk(clk),
    .rst_n(rst_n),
    .rise(dir_rise[2]),
    .smooth(dir_btn[2])
);
key_detect u_key_down(
    .key_in(dir_btn_raw[1]),
    .clk(clk),
    .rst_n(rst_n),
    .rise(dir_rise[1]),
    .smooth(dir_btn[1])
);
key_detect u_key_mid(
    .key_in(dir_btn_raw[0]),
    .clk(clk),
    .rst_n(rst_n),
    .rise(dir_rise[0]),
    .smooth(dir_btn[0])
);
wire admin_btn_rise;
wire set_pwd_btn_rise;
key_detect u_admin_btn(
    .key_in(admin_btn_raw),
    .clk(clk),
    .rst_n(rst_n),
    .rise(admin_btn_rise),
    .smooth(admin_btn)
);

key_detect u_set_pwd_btn(
    .key_in(set_pwd_btn_raw),
    .clk(clk),
    .rst_n(rst_n),
    .rise(set_pwd_btn_rise),
    .smooth(set_pwd_btn)
);

// 显示模块
DISP u_display(
    //in
    .clk(clk),
    .rst_n(rst_n),
    .seg_disp_num(seg_disp_num),
    .LED16_switch(LED16_switch),
    .RGB_LED_switch_1(RGB_LED_switch_1),
    .RGB_LED_switch_2(RGB_LED_switch_2),
    //out
    .seg_select(seg_sel),
    .tube_part(tube_sel),
    .out_LED16(led16),
    .out_RGB_LED_1(RGB_led_1),
    .out_RGB_LED_2(RGB_led_2)
);


// 无操作计时器
silent10s_detect u_silent10(
    .clk(clk),
    .rst_n(rst_n),
    .dir_btn(dir_btn),
    .admin_btn(admin_btn),
    .set_pwd_btn(set_pwd_btn),
    //out 
    .silent_10s(c_silent_10s)
);

silent20s_detect u_silent20(
    .clk(clk),
    .rst_n(rst_n),
    .dir_btn(dir_btn),
    .admin_btn(admin_btn),
    .set_pwd_btn(set_pwd_btn),
    //out 
    .silent_20s(c_silent_20s)
);

///////////////////////////////////////// 状态机
// 第一段状态机
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)begin
		current_state <= s_wait;				//复位初始状态
    end
	else
		current_state <= next_state;		//次态转移到现态
end

// 第二段状态机
reg [15:0]num_reg ;
always @(posedge clk)
begin
    if (!rst_n)begin
    err_cnt <= 0;
    pwd_set <= 0;
    end
case (current_state)
    s_wait : begin
        num_reg <= 0;
        if (dir_rise[0])begin
            next_state <= s_pwd_set_0b;
            pwd_opr_mode <= pwd_check;  
        end
        else if (set_pwd_btn_rise)begin
            next_state <= s_pwd_set_0b;
            pwd_opr_mode <= pwd_reconfig;            
        end
    end 
    s_change : begin
        if (dir_rise[0] || c_silent_10s)begin
            next_state <= s_wait;
            err_cnt <= 0;
        end
    end
    s_pwd_set_0b : begin
        if (dir_rise[3])
        next_state <= s_pwd_set_1b;
        else if (c_silent_10s)
        next_state <=s_wait;
        if(dir_rise[2])begin
            if (num_reg[3:0] <= 4'b1000)
            num_reg[3:0] <= num_reg[3:0]+1'b1;
            else
            num_reg[3:0] <= 0;
        end
        if(dir_rise[1])begin
            if (num_reg[3:0] >= 4'b0001)
            num_reg[3:0] <= num_reg[3:0]-1'b1;
            else
            num_reg[3:0] <= 4'b1001;
        end
    end
    s_pwd_set_1b : begin
        if (dir_rise[3])
        next_state <= s_pwd_set_2b;
        else if (dir_rise[4])
        next_state <= s_pwd_set_0b;
        else if (c_silent_10s)
        next_state <=s_wait;
        if(dir_rise[2])begin
            if (num_reg[7:4] <= 4'b1000)
            num_reg[7:4] <= num_reg[7:4]+1'b1;
            else
            num_reg[7:4] <= 0;
        end
        if(dir_rise[1])begin
            if (num_reg[7:4] >= 4'b0001)
            num_reg[7:4] <= num_reg[7:4]-1'b1;
            else
            num_reg[7:4] <= 4'b1001;
        end
    end
    s_pwd_set_2b : begin
        if (dir_rise[3])
        next_state <= s_pwd_set_3b;
        else if (dir_rise[4])
        next_state <= s_pwd_set_1b;
        else if (c_silent_10s)
        next_state <=s_wait;
        if(dir_rise[2])begin
            if (num_reg[11:8] <= 4'b1000)
            num_reg[11:8] <= num_reg[11:8]+1'b1;
            else
            num_reg[11:8] <= 0;
        end
        if(dir_rise[1])begin
            if (num_reg[11:8] >= 4'b0001)
            num_reg[11:8] <= num_reg[11:8]-1'b1;
            else
            num_reg[11:8] <= 4'b1001;
        end
    end
    s_pwd_set_3b : begin
        if (dir_rise[3])
        next_state <= s_pwd_set_4b;
        else if (dir_rise[4])
        next_state <= s_pwd_set_2b;
        else if (c_silent_10s)
        next_state <=s_wait;
        if(dir_rise[2])begin
            if (num_reg[15:12] <= 4'b1000)
            num_reg[15:12] <= num_reg[15:12]+1'b1;
            else
            num_reg[15:12] <= 0;
        end
        if(dir_rise[1])begin
            if (num_reg[15:12] >= 4'b0001)
            num_reg[15:12] <= num_reg[15:12]-1'b1;
            else
            num_reg[15:12] <= 4'b1001;
        end
    end
    s_pwd_set_4b : begin
        if (dir_btn[0])begin
        if (pwd_opr_mode == pwd_check)begin
            if (num_reg == pwd_set)begin
                next_state <= s_unlock;
            end
            else if ((num_reg != pwd_set) && (err_cnt <= 2'b01))begin
                next_state <= s_err_no_warn;
            end
            else if ((num_reg != pwd_set) && (err_cnt == 2'b10))begin
                next_state <= s_warn;
            end
        end
        else if (pwd_opr_mode == pwd_reconfig)begin
            next_state <= s_change;
            pwd_set <= num_reg;
        end
        end
        else if (dir_btn[4])begin
            next_state <= s_pwd_set_3b;
        end
        else if (c_silent_10s)
            next_state <=s_wait;
    end
    s_err_no_warn : begin
        if (dir_rise[0] || c_silent_10s)begin
            next_state <= s_wait;
            err_cnt <= err_cnt + 2'b1;
        end  
    end
    s_warn : begin
        if (admin_btn_rise)begin
        next_state <= s_wait;
        err_cnt <= 0;
        end
    end
    s_unlock : begin
        if (dir_rise[0] || c_silent_20s)begin
            next_state <= s_wait;
            err_cnt <= 0;
        end
        
    end
    default: next_state <= s_wait;
endcase
end
// 第三段状态机
always @(posedge clk)
begin
    case (current_state)
        s_wait : begin
            seg_disp_num <= {{4{seg_null}},seg_l,seg_0,seg_c,seg_k};
            RGB_LED_switch_1 <= 0; 
            RGB_LED_switch_2 <= 0;    
            LED16_switch <= 2'b11;     
        end
        s_change : begin
            RGB_LED_switch_1 <= 3'b101;             // 设置完密码亮紫灯
            RGB_LED_switch_2 <= 3'b101;
            seg_disp_num <= {{2{seg_null}},seg_c,seg_h,seg_a,seg_n,seg_g,seg_e};
        end
        s_pwd_set_0b : begin
            seg_disp_num <= {1'b0,num_reg[3:0],{3{seg_null}},{4{seg_null}}};
            RGB_LED_switch_1 <= 3'b000;                                 
            RGB_LED_switch_2 <= 3'b000;                                 
        end
        s_pwd_set_1b : begin
            seg_disp_num <= {1'b0,num_reg[3:0],1'b0,num_reg[7:4],{2{seg_null}},{4{seg_null}}};
            RGB_LED_switch_1 <= 3'b001;                                 // 黄灯(其实像白色)
            RGB_LED_switch_2 <= 3'b000;                                 // 蓝灯
        end
        s_pwd_set_2b: begin
            seg_disp_num <= {1'b0,num_reg[3:0],1'b0,num_reg[7:4],1'b0,num_reg[11:8],{1{seg_null}},{4{seg_null}}};
            RGB_LED_switch_1 <= 3'b000;                                 // 蓝灯
            RGB_LED_switch_2 <= 3'b001;                                 // 蓝灯
        end
        s_pwd_set_3b: begin
            seg_disp_num <= {1'b0,num_reg[3:0],1'b0,num_reg[7:4],1'b0,num_reg[11:8],1'b0,num_reg[15:12],{4{seg_null}}};
            RGB_LED_switch_1 <= 3'b001;                                 // 蓝灯
            RGB_LED_switch_2 <= 3'b001;                                 // 蓝灯
        end
        s_pwd_set_4b: begin
            seg_disp_num <= {1'b0,num_reg[3:0],1'b0,num_reg[7:4],1'b0,num_reg[11:8],1'b0,num_reg[15:12],{4{seg_null}}};    
            RGB_LED_switch_1 <= 3'b011;                                 // 蓝灯
            RGB_LED_switch_2 <= 3'b011;                                 // 蓝灯
        end
        s_err_no_warn: begin        
            seg_disp_num <= {3'b0,err_cnt+2'b1,{4{seg_null}},seg_e,seg_r,seg_r};
            LED16_switch <= 2'b10;                                      // 闪烁           
            RGB_LED_switch_1 <= 3'b100;                                 // 红灯
            RGB_LED_switch_2 <= 3'b001;                                 // 蓝灯
        end
        s_warn : begin
            seg_disp_num <= {{3{seg_null}},seg_e,seg_r,seg_r,seg_0,seg_r};
            LED16_switch <= 2'b10;                                      // 闪烁
            RGB_LED_switch_1 <= 3'b100;                                 // 红灯
            RGB_LED_switch_2 <= 3'b100;                                 // 红灯
        end
        s_unlock : begin
            seg_disp_num <= {{2{seg_null}},seg_u,seg_n,seg_l,seg_0,seg_c,seg_k};
            LED16_switch <= 2'b01;                                      // 全亮
            RGB_LED_switch_1 <= 3'b010;                                 // 绿灯
            RGB_LED_switch_2 <= 3'b010;                                 // 绿灯

        end
        default: begin
            seg_disp_num <= {8{seg_null}};
            RGB_LED_switch_1 <= 0; 
            RGB_LED_switch_2 <= 0;
            LED16_switch <= 2'b00;
        end
    endcase
end
endmodule
