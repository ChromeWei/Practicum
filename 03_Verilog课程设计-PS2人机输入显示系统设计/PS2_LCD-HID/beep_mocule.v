//---------------------------------------------------------------------------
//--	文件�?	:	Beep_Module.v
//--	作�?	:	ZIRCON
//--	描述		:	蜂鸣器发声模�?
//--	修订历史	:	2014-1-1
//---------------------------------------------------------------------------
module Beep_Module
(
	//输入端口
	CLK_20M,RST_N,KEY,
	//输出端口
	BEEP
);

//---------------------------------------------------------------------------
//--	外部端口声明
//---------------------------------------------------------------------------
input					CLK_20M;					//时钟的端�?开发板用的50MHz晶振
input					RST_N;					//复位的端�?低电平复�?
input 	[ 7:0]	KEY;						//按键端口
output				BEEP;						//蜂鸣器端�?

//---------------------------------------------------------------------------
//--	内部端口声明
//---------------------------------------------------------------------------
reg		[19:0]	time_cnt;				//用来控制蜂鸣器发声频率的定时计数�?
reg		[19:0]	time_cnt_n;				//time_cnt的下一个状�?
reg		[15:0]	freq;						//各种音调的分频�?
reg		[15:0]	freq_n;					//各种音调的分频�?
reg					beep_reg;				//用来控制蜂鸣器发声的寄存�?
reg					beep_reg_n;				//beep_reg的下一个状�?

//---------------------------------------------------------------------------
//--	逻辑功能实现	
//---------------------------------------------------------------------------
//时序电路，用来给time_cnt寄存器赋�?
always @ (posedge CLK_20M or negedge RST_N)
begin
	if(!RST_N)									//判断复位
		time_cnt <= 1'b0;						//初始化time_cnt�?
	else
		time_cnt <= time_cnt_n;				//用来给time_cnt赋�?
end

//组合电路,判断频率,让定时器累加 
always @ (*)
begin
	if(time_cnt == freq)						//判断分频�?
		time_cnt_n = 1'b0;					//定时器清零操�?
	else
		time_cnt_n = time_cnt + 1'b1;		//定时器累加操�?

end

//时序电路，用来给beep_reg寄存器赋�?
always @ (posedge CLK_20M or negedge RST_N)
begin
	if(!RST_N)									//判断复位
		beep_reg <= 1'b0;						//初始化beep_reg�?
	else
		beep_reg <= beep_reg_n;				//用来给beep_reg赋�?
end

//组合电路,判断频率,使蜂鸣器发声
always @ (*)
begin
	if(time_cnt == freq)						//判断分频�?
		beep_reg_n = ~beep_reg;				//改变蜂鸣器的状�?
	else
		beep_reg_n = beep_reg;				//蜂鸣器的状态保持不�?
end

//时序电路，用来给beep_reg寄存器赋�?
always @ (posedge CLK_20M or negedge RST_N)
begin
	if(!RST_N)									//判断复位
		freq <= 1'b0;							//初始化beep_reg�?
	else
		freq <= freq_n;						//用来给beep_reg赋�?
end

//组合电路，按键选择分频值来实现蜂鸣器发出不同声�?
//中音do的频率为523.3hz，freq = 50 * 10^6 / (523 * 2) = 47774
always @ (*)
begin
	case(KEY)
		8'h70: freq_n = 16'd0;			//没有声音
		8'h69: freq_n = 16'd47774; 	//中音1的频率�?62Hz
		8'h72: freq_n = 16'd42568; 	//中音2的频率�?87.3Hz
		8'h7A: freq_n = 16'd37919; 	//中音3的频率�?59.3Hz
		8'h6B: freq_n = 16'd35791; 	//中音4的频率�?98.5Hz
		8'h73: freq_n = 16'd31888; 	//中音5的频率�?84Hz
		8'h74: freq_n = 16'd28409; 	//中音6的频率�?80Hz
		8'h6C: freq_n = 16'd25309; 	//中音7的频率�?87.8Hz
		8'h75: freq_n = 16'd23889; 	//高音1的频率�?046.5Hz
		8'h7D: freq_n = 16'd21276; 	//高音2的频率�?175Hz
		default	  : freq_n = freq;
	endcase
end

assign BEEP = beep_reg;		//最�?将寄存器的值赋值给端口BEEP

endmodule



