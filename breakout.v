module divfreq(input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
	begin
		if(Count > 50000)
		begin
			Count <= 24'b0;
			CLK_div <= ~CLK_div;
		end
		else
			Count <= Count + 1'b1;
	end
endmodule

module divmove(input stop, input CLK, output reg CLK_div);
	reg [24:0] Count;
	always @(posedge CLK)
	begin
		if(Count > 3000000)
		begin
			Count <= 24'b0;
			CLK_div <= ~CLK_div;
		end
		else
		begin
		   if(stop)
				Count <= Count;
			else
				Count <= Count + 1'b1;
	   end
	end
endmodule

module breakout(
	input CLK,	//不用接啦爽
	input Left, //keep &右移
	input Right, //keep & 右移
	input shoot,
	input stop,
	input [3:0]back, //背景變化(關卡)
	output [7:0]lightRed,
	output [7:0]lightGreen,
	output [7:0]lightBlue,
	output reg [2:0] Col, //控制亮哪排
	output EN,
	output reg[7:0]win, //得分
	output reg beep, //蜂鳴
	input musicchange
);

reg [7:0] state [7:0];	//表示哪些燈有亮 方便看&判斷是否打到磚塊的條件
reg [7:0] stateR[7:0];	//表r 
reg [7:0] stateG [7:0];	//表g
reg [7:0] stateB [7:0]; //表b
integer i, center, alreadyShoot, ball_x, ball_y, direction, forward, mode, round, point;
reg [22:0] j;
reg clk;
reg [16:0] count,div_num;
reg [7:0] music;


always @(posedge CLK)	//4hz
begin
	if(j==23'h47868c)
		begin
			j<=0;
			clk=~clk;
		end
		else
			j=j+1'b1;
end
always @(posedge clk)
	begin
	if(musicchange==0)
		begin
			if(music==8'd183)	//183個音
				music<=0;
			else
				music<=music+1'b1;
		end
	else
		begin
			if(music==8'd208)	//208個音
				music<=0;
			else
				music<=music+1'b1;
		end
		
	end
always @(posedge CLK)
	begin
		if(count==div_num)
			begin
				count<=0;
				beep=~beep;
			end
		else if(div_num==0)
			beep=~beep;
		else
			count<=count+1'b1;
	end

parameter 
	L1=17'h1754e,
	L2=17'h14c81,
	L3=17'h1284a,
	L4=17'h117A8,
	L5=17'h14e70,
	L6=17'h0ddf2,
	L7=17'h0c5ba,
	M1=17'h0ba9e,	//DO
	M2=17'h0a648,	//RE
	M3=17'h0941f,	//ME
	M4=17'h08bcf,	//FA
	M5=17'h07c90,	//SO
	M6=17'h06ef9,	//LA
	M7=17'h062dd,	//SI
	H1=17'h05d68,
	H2=17'h05322,
	H3=17'h04a11,
	H4=17'h045e9,
	H5=17'h3e48,
	H6=17'h377d,
	H7=17'h316f;

	

	always @(posedge clk)
	begin
	if(musicchange==1)
	begin
			case(music)	//尖銳版泡沫
			8'd0 : div_num=M1;
			8'd1 : div_num=M1;
			8'd2 : div_num=M1;
			8'd3 : div_num=M1;
			8'd4 : div_num=M3;
			8'd5 : div_num=M3;
			8'd6 : div_num=M5;
			8'd7 : div_num=M5;
			8'd8 : div_num=M6;
			8'd9 : div_num=M6;
			8'd10 : div_num=M6;
			8'd11 : div_num=M6;
			8'd12 : div_num=17'h1;
			8'd13 : div_num=17'h1;
			8'd14 : div_num=M6;
			8'd15 : div_num=M6;
			8'd16 : div_num=M6;
			8'd17 : div_num=M6;
			8'd18 : div_num=M5;
			8'd19 : div_num=M5;
			8'd20 : div_num=M6;
			8'd21 : div_num=M6;
			8'd22 : div_num=M5;
			8'd23 : div_num=M5;
			8'd24 : div_num=M5;
			8'd25 : div_num=M5;
			8'd26 : div_num=M2;
			8'd27 : div_num=M2;
			8'd28 : div_num=M2;
			8'd29 : div_num=M2;
			8'd30 : div_num=M2;
			8'd31 : div_num=M2;
			8'd32 : div_num=M2;
			8'd33 : div_num=M2;
			8'd34 : div_num=M1;
			8'd35 : div_num=M1;
			8'd36 : div_num=M2;
			8'd37 : div_num=M2;
			8'd38 : div_num=M3;
			8'd39 : div_num=M3;
			8'd40 : div_num=M3;
			8'd41 : div_num=M3;
			8'd42 : div_num=0;
			8'd43 : div_num=0;
			8'd44 : div_num=M3;
			8'd45 : div_num=M3;
			8'd46 : div_num=M3;
			8'd47 : div_num=M3;
			8'd48 : div_num=M2;
			8'd49 : div_num=M2;
			8'd50 : div_num=M3;
			8'd51 : div_num=M3;
			8'd52 : div_num=M2;
			8'd53 : div_num=M2;
			8'd54 : div_num=M2;
			8'd55 : div_num=M2;
			8'd56 : div_num=M1;
			8'd57 : div_num=M1;
			8'd58 : div_num=M1;
			8'd59 : div_num=M1;
			8'd60 : div_num=M1;
			8'd61 : div_num=M1;
			8'd62 : div_num=M1;
			8'd63 : div_num=M1;
			8'd64 : div_num=M2;
			8'd65 : div_num=M2;
			8'd66 : div_num=M3;
			8'd67 : div_num=M3;
			8'd68 : div_num=M4;
			8'd69 : div_num=M4;
			8'd70 : div_num=M4;
			8'd71 : div_num=M4;
			8'd72 : div_num=0;
			8'd73 : div_num=0;
			8'd74 : div_num=M4;
			8'd75 : div_num=M4;
			8'd76 : div_num=M4;
			8'd77 : div_num=M4;
			8'd78 : div_num=M3;
			8'd79 : div_num=M3;
			8'd80 : div_num=M4;
			8'd81 : div_num=M4;
			8'd82 : div_num=M3;
			8'd83 : div_num=M3;
			8'd84 : div_num=M3;
			8'd85 : div_num=M3;
			8'd86 : div_num=M2;
			8'd87 : div_num=M2;
			8'd88 : div_num=M2;
			8'd89 : div_num=M2;
			8'd90 : div_num=M2;
			8'd91 : div_num=M2;
			8'd92 : div_num=M2;
			8'd93 : div_num=M2;
			8'd94 : div_num=M2;
			8'd95 : div_num=M2;
			8'd96 : div_num=M1;
			8'd97 : div_num=M1;
			8'd98 : div_num=M2;
			8'd99 : div_num=M2;
			8'd100: div_num=M1;
			8'd101: div_num=M1;
			8'd102: div_num=0;
			8'd103: div_num=0;
			8'd104: div_num=0;
			8'd105: div_num=0;
			8'd106: div_num=0;
			8'd107: div_num=0;
			8'd108: div_num=H3;
			8'd109: div_num=H3;
			8'd110: div_num=H3;
			8'd111: div_num=H3;
			8'd112: div_num=H3;
			8'd113: div_num=H3;
			8'd114: div_num=H3;
			8'd115: div_num=H3;
			8'd116: div_num=H2;
			8'd117: div_num=H2;
			8'd118: div_num=H2;
			8'd119: div_num=H2;
			8'd120: div_num=0;
			8'd121: div_num=0;
			8'd122: div_num=H3;
			8'd123: div_num=H3;
			8'd124: div_num=H4;
			8'd125: div_num=H4;
			8'd126: div_num=H5;
			8'd127: div_num=H5;
			8'd128: div_num=H5;
			8'd129: div_num=H5;
			8'd130: div_num=H2;
			8'd131: div_num=H2;
			8'd132: div_num=H2;
			8'd133: div_num=H2;
			8'd134: div_num=0;
			8'd135: div_num=0;
			8'd136: div_num=H2;
			8'd137: div_num=H2;
			8'd138: div_num=H2;
			8'd139: div_num=H2;
			8'd140: div_num=H2;
			8'd141: div_num=H2;
			8'd142: div_num=H2;
			8'd143: div_num=H2;
			8'd144: div_num=H1;
			8'd145: div_num=H1;
			8'd146: div_num=H3;
			8'd147: div_num=H3;
			8'd148: div_num=0;
			8'd149: div_num=0;
			8'd150: div_num=H3;
			8'd151: div_num=H3;
			8'd152: div_num=H5;
			8'd153: div_num=H5;
			8'd154: div_num=H6;
			8'd155: div_num=H6;
			8'd156: div_num=H6;
			8'd157: div_num=H6;
			8'd158: div_num=H3;
			8'd159: div_num=H3;
			8'd160: div_num=H3;
			8'd161: div_num=H3;
			8'd162: div_num=0;
			8'd163: div_num=0;
			8'd164: div_num=H3;
			8'd165: div_num=H3;
			8'd166: div_num=H3;
			8'd167: div_num=H3;
			8'd168: div_num=H3;
			8'd169: div_num=H3;
			8'd170: div_num=H3;
			8'd171: div_num=H3;
			8'd172: div_num=H2;
			8'd173: div_num=H2;
			8'd174: div_num=H2;
			8'd175: div_num=H2;
			8'd176: div_num=0;
			8'd177: div_num=0;
			8'd178: div_num=H3;
			8'd179: div_num=H3;
			8'd180: div_num=H4;
			8'd181: div_num=H4;
			8'd182: div_num=H5;
			8'd183: div_num=H5;
			8'd184: div_num=H5;
			8'd185: div_num=H5;
			8'd186: div_num=H2;
			8'd187: div_num=H2;
			8'd188: div_num=H2;
			8'd189: div_num=H2;
			8'd190: div_num=H2;
			8'd191: div_num=H2;
			8'd192: div_num=H2;
			8'd193: div_num=H2;
			8'd194: div_num=H2;
			8'd195: div_num=H2;
			8'd196: div_num=H2;
			8'd197: div_num=H2;
			8'd198: div_num=H1;
			8'd199: div_num=H1;
			8'd200: div_num=H3;
			8'd201: div_num=H3;
			8'd202: div_num=0;
			8'd203: div_num=0;
			8'd204: div_num=0;
			8'd205: div_num=0;
			8'd206: div_num=0;
			8'd207: div_num=0;
			endcase
			end
			
else
begin
		case(music)	//雜音很多的千本櫻
			8'd0 : div_num=M6;	
			8'd1 : div_num=M6;
			8'd2 : div_num=M5;
			8'd3 : div_num=M5;
			8'd4 : div_num=M6;
			8'd5 : div_num=H1;
			8'd6 : div_num=H2;
			8'd7 : div_num=H3;
			8'd8 : div_num=M6;	
			8'd9 : div_num=M6;
			8'd10 : div_num=M5;
			8'd11 : div_num=M6;
			8'd12 : div_num=M5;
			8'd13 : div_num=M3;
			8'd14 : div_num=M5;
			8'd15 : div_num=M6;
			8'd16 : div_num=M6;	
			8'd17 : div_num=M5;
			8'd18 : div_num=M6;
			8'd19 : div_num=H1;
			8'd20 : div_num=H2;
			8'd21 : div_num=H3;
			8'd22 : div_num=H3;
			8'd23 : div_num=H2;
			8'd24 : div_num=H1;	
			8'd25 : div_num=M6;
			8'd26 : div_num=M6;
			8'd27 : div_num=M5;
			8'd28 : div_num=M6;	
			8'd29 : div_num=H1;
			8'd30 : div_num=H2;
			8'd31 : div_num=H3;
			8'd32 : div_num=M6;
			8'd33 : div_num=M6;
			8'd34 : div_num=M5;
			8'd35 : div_num=M6;
			8'd36 : div_num=M5;	
			8'd37 : div_num=M5;
			8'd38 : div_num=M3;
			8'd39 : div_num=M6;
			8'd40 : div_num=M6;
			8'd41 : div_num=M5;
			8'd42 : div_num=M5;
			8'd43 : div_num=M6;
			8'd44 : div_num=H1;	
			8'd45 : div_num=H2;
			8'd46 : div_num=H3;
			8'd47 : div_num=H2;
			8'd48 : div_num=H1;
			8'd49 : div_num=M6;
			8'd50 : div_num=H1;
			8'd51 : div_num=M7;
			8'd52 : div_num=M6;	
			8'd53 : div_num=M5;
			8'd54 : div_num=M5;
			8'd55 : div_num=M5;
			8'd56 : div_num=M6;	
			8'd57 : div_num=M3;
			8'd58 : div_num=M2;
			8'd59 : div_num=M3;
			8'd60 : div_num=M3;
			8'd61 : div_num=M5;
			8'd62 : div_num=M6;
			8'd63 : div_num=H2;
			8'd64 : div_num=M7;	
			8'd65 : div_num=H1;
			8'd66 : div_num=M7;
			8'd67 : div_num=M5;
			8'd68 : div_num=M6;
			8'd69 : div_num=H1;
			8'd70 : div_num=M7;
			8'd71 : div_num=M6;
			8'd72 : div_num=M5;	
			8'd73 : div_num=M5;
			8'd74 : div_num=M5;
			8'd75 : div_num=M6;
			8'd76 : div_num=M3;
			8'd77 : div_num=M2;
			8'd78 : div_num=M3;
			8'd79 : div_num=M3;
			8'd80 : div_num=M5;	
			8'd81 : div_num=M6;
			8'd82 : div_num=M6;
			8'd83 : div_num=M6;
			8'd84 : div_num=H1;	
			8'd85 : div_num=H2;
			8'd86 : div_num=M7;
			8'd87 : div_num=M6;
			8'd88 : div_num=H1;
			8'd89 : div_num=H2;
			8'd90 : div_num=H2;
			8'd91 : div_num=H3;
			8'd92 : div_num=H3;	
			8'd93 : div_num=H3;
			8'd94 : div_num=H5;
			8'd95 : div_num=H6;
			8'd96 : div_num=H2;
			8'd97 : div_num=H1;
			8'd98 : div_num=H3;
			8'd99 : div_num=M6;
			8'd100: div_num=H1;	
			8'd101: div_num=H2;
			8'd102: div_num=H2;
			8'd103: div_num=H3;
			8'd104: div_num=H3;
			8'd105: div_num=H3;
			8'd106: div_num=H3;
			8'd107: div_num=H4;
			8'd108: div_num=H3;	
			8'd109: div_num=H2;
			8'd110: div_num=H1;
			8'd111: div_num=H1;
			8'd112: div_num=M6;	
			8'd113: div_num=H1;
			8'd114: div_num=H2;
			8'd115: div_num=H2;
			8'd116: div_num=H3;
			8'd117: div_num=H3;
			8'd118: div_num=H3;
			8'd119: div_num=H5;
			8'd120: div_num=H6;	
			8'd121: div_num=H2;
			8'd122: div_num=H1;
			8'd123: div_num=H3;
			8'd124: div_num=M6;
			8'd125: div_num=H1;
			8'd126: div_num=H4;
			8'd127: div_num=H3;
			8'd128: div_num=H2;	
			8'd129: div_num=H1;
			8'd130: div_num=H1;
			8'd131: div_num=H2;
			8'd132: div_num=M7;
			8'd133: div_num=M5;
			8'd134: div_num=M6;
			8'd135: div_num=M6;
			8'd136: div_num=H1;	
			8'd137: div_num=H2;
			8'd138: div_num=H2;
			8'd139: div_num=H3;
			8'd140 : div_num=H3;	
			8'd141 : div_num=H3;
			8'd142 : div_num=H5;
			8'd143 : div_num=H6;
			8'd144 : div_num=H2;
			8'd145 : div_num=H1;
			8'd146 : div_num=H3;
			8'd147 : div_num=M6;
			8'd148 : div_num=H1;	
			8'd149 : div_num=H2;
			8'd150 : div_num=H2;
			8'd151 : div_num=H3;
			8'd152 : div_num=H3;
			8'd153 : div_num=H3;
			8'd154 : div_num=H3;
			8'd155 : div_num=H4;
			8'd156 : div_num=H3;	
			8'd157 : div_num=H2;
			8'd158 : div_num=H1;
			8'd159 : div_num=H1;
			8'd160 : div_num=M6;
			8'd161 : div_num=H1;
			8'd162 : div_num=H2;
			8'd163 : div_num=H2;
			8'd164 : div_num=H3;	
			8'd165 : div_num=H3;
			8'd166 : div_num=H3;
			8'd167 : div_num=H5;
			8'd168 : div_num=H6;	
			8'd169 : div_num=H2;
			8'd170 : div_num=H1;
			8'd171 : div_num=H3;
			8'd172 : div_num=M6;
			8'd173 : div_num=H1;
			8'd174 : div_num=H4;
			8'd175 : div_num=H3;
			8'd176 : div_num=H2;	
			8'd177 : div_num=H1;
			8'd178 : div_num=H2;
			8'd179 : div_num=H1;
			8'd180 : div_num=H3;
			8'd181 : div_num=H5;
			8'd182 : div_num=H6;

			endcase
	end
end


initial
begin
   round = 0;	//關卡background
	center = 4;
	Col=0;	//控制哪直排亮
	alreadyShoot = 0;
	ball_x = 4;	//球的X座標
	ball_y = 6;	//球的y座標
	mode = 11;	//反彈模式
	point = 0;	//分數
end

divfreq f0(CLK, CLK_div);
divmove f1(stop, CLK, CLK_move);

always @(posedge CLK_move)
begin
	case (back)	//關卡x4
	    4'b0000: round=0;
		 4'b0001: round=1;
       4'b0010: round=2;
       4'b0100: round=3;
       4'b1000: round=4;
   endcase
	if(round==1)	//第一關
	begin
		 win<=8'b00000000;
	  for (i=0;i<8;i=i+1)
	  begin
       state[i] = 8'b00001111;
		 stateR[i] = 8'b00000000;
		 stateG[i] = 8'b00001111;
		 stateB[i] = 8'b00001111;
		 
	    if (i>=0 & i<=2)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==1)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(round==2)	//第二關
	begin
	  win<=8'b00000000;
	  state[0] = 8'b00001011;
	  state[1] = 8'b00001101;
	  state[2] = 8'b00001011;
	  state[3] = 8'b00001101;
  	  state[4] = 8'b00001011;
	  state[5] = 8'b00001101;
	  state[6] = 8'b00001011;
	  state[7] = 8'b00001101;
	  
	  stateR[0] = 8'b00000000;
	  stateR[1] = 8'b00000000;
	  stateR[2] = 8'b00000000;
	  stateR[3] = 8'b00000000;
	  stateR[4] = 8'b00000000;
	  stateR[5] = 8'b00000000;
	  stateR[6] = 8'b00000000;
	  stateR[7] = 8'b00000000;
	  
	  stateG[0] = 8'b00001011;
	  stateG[1] = 8'b00001101;
	  stateG[2] = 8'b00001011;
	  stateG[3] = 8'b00001101;
  	  stateG[4] = 8'b00001011;
	  stateG[5] = 8'b00001101;
	  stateG[6] = 8'b00001011;
	  stateG[7] = 8'b00001101;
	  
	  stateB[0] = 8'b00001011;
	  stateB[1] = 8'b00001101;
	  stateB[2] = 8'b00001011;
	  stateB[3] = 8'b00001101;
  	  stateB[4] = 8'b00001011;
	  stateB[5] = 8'b00001101;
	  stateB[6] = 8'b00001011;
	  stateB[7] = 8'b00001101;
		 
	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=0 & i<=2)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==1)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(round==3) //第三關，笑
	begin
	  win<=8'b00000000;
	  state[0] = 8'b00000000;
	  state[1] = 8'b00000100;
	  state[2] = 8'b00010010;
	  state[3] = 8'b00010100;
	  state[4] = 8'b00010000;
	  state[5] = 8'b00010100;
	  state[6] = 8'b00010010;
	  state[7] = 8'b00000100;
	  
	  stateR[0] = 8'b00000000;
	  stateR[1] = 8'b00000000;
	  stateR[2] = 8'b00000000;
	  stateR[3] = 8'b00000000;
	  stateR[4] = 8'b00000000;
	  stateR[5] = 8'b00000000;
	  stateR[6] = 8'b00000000;
	  stateR[7] = 8'b00000000;
	  
	  stateG[0] = 8'b00000000;
	  stateG[1] = 8'b00000100;
	  stateG[2] = 8'b00010010;
	  stateG[3] = 8'b00010100;
	  stateG[4] = 8'b00010000;
	  stateG[5] = 8'b00010100;
	  stateG[6] = 8'b00010010;
	  stateG[7] = 8'b00000100;
	  
	  stateB[0] = 8'b00000000;
	  stateB[1] = 8'b00000100;
	  stateB[2] = 8'b00010010;
	  stateB[3] = 8'b00010100;
	  stateB[4] = 8'b00010000;
	  stateB[5] = 8'b00010100;
	  stateB[6] = 8'b00010010;
	  stateB[7] = 8'b00000100;

	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=0 & i<=2)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==1)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(round==4)	//第四關
	begin
	  win<=8'b00000000;
	  state[0] = 8'b00000011;
	  state[1] = 8'b00000011;
	  state[2] = 8'b00000100;
	  state[3] = 8'b00001110;
  	  state[4] = 8'b00001110;
	  state[5] = 8'b00000100;
	  state[6] = 8'b00000011;
	  state[7] = 8'b00000011;
	  
	  stateR[0] = 8'b00000000;
	  stateR[1] = 8'b00000000;
	  stateR[2] = 8'b00000000;
	  stateR[3] = 8'b00000000;
	  stateR[4] = 8'b00000000;
	  stateR[5] = 8'b00000000;
	  stateR[6] = 8'b00000000;
	  stateR[7] = 8'b00000000;
	  
	  stateG[0] = 8'b00000011;
	  stateG[1] = 8'b00000011;
	  stateG[2] = 8'b00000100;
	  stateG[3] = 8'b00001110;
  	  stateG[4] = 8'b00001110;
	  stateG[5] = 8'b00000100;
	  stateG[6] = 8'b00000011;
	  stateG[7] = 8'b00000011;
	  
	  stateB[0] = 8'b00000011;
	  stateB[1] = 8'b00000011;
	  stateB[2] = 8'b00000100;
	  stateB[3] = 8'b00001110;
  	  stateB[4] = 8'b00001110;
	  stateB[5] = 8'b00000100;
	  stateB[6] = 8'b00000011;
	  stateB[7] = 8'b00000011;
	  
	  for (i=0;i<8;i=i+1)
	  begin
	    if (i>=0 & i<=2)
		 begin
		   state[i][7]=1;
			stateR[i][7]=0;
			stateG[i][7]=0;
			stateB[i][7]=1;
		 end
		 if (i==1)
		 begin
         state[i][6] = 1;
			stateR[i][6] = 1;
			stateG[i][6] = 1;
			stateB[i][6] = 1;
		 end
	  end
	end
	
	if(round==0)	//開始玩需切0000
	begin
	if(point>0)	//計算分數
	begin
	   if(point==0)   win<=8'b00000000;	//得一分亮一顆燈
		else if(point==1)   win<=8'b00000001;
		else if(point==2)   win<=8'b00000011;
		else if(point==3)   win<=8'b00000111;
		else if(point==4)   win<=8'b00001111;
	   else if(point==5)   win<=8'b00011111;
	   else if(point==6)   win<=8'b00111111;
	   else if(point==7)   win<=8'b01111111;
	   else if(point==8)   
		begin //贏了
		   win<=8'b11111111;	//紅色愛心
			state[0] = 8'b00001110;
			state[1] = 8'b00011111;
			state[2] = 8'b00111111;
			state[3] = 8'b01111110;
			state[4] = 8'b01111110;
			state[5] = 8'b00111111;
			state[6] = 8'b00011111;
			state[7] = 8'b00001110;
			
			stateR[0] = 8'b00001110;
			stateR[1] = 8'b00011111;
			stateR[2] = 8'b00111111;
			stateR[3] = 8'b01111110;
			stateR[4] = 8'b01111110;
			stateR[5] = 8'b00111111;
			stateR[6] = 8'b00011111;
			stateR[7] = 8'b00001110;
			
			stateG[0] = 8'b00000000;
			stateG[1] = 8'b00000000;
			stateG[2] = 8'b00000000;
			stateG[3] = 8'b00000000;
			stateG[4] = 8'b00000000;
			stateG[5] = 8'b00000000;
			stateG[6] = 8'b00000000;
			stateG[7] = 8'b00000000;

			stateB[0] = 8'b00000000;
			stateB[1] = 8'b00000000;
			stateB[2] = 8'b00000000;
			stateB[3] = 8'b00000000;
			stateB[4] = 8'b00000000;
			stateB[5] = 8'b00000000;
			stateB[6] = 8'b00000000;
			stateB[7] = 8'b00000000;
			
			round=0;
			center = 1;
			alreadyShoot = 0;
			ball_x = 1;
			ball_y = 6;
			mode = 11;
			point=0;
		end
	end
	
	if (Left)	//底板左移
	begin
		if (center-2 >= 0)	//防超出邊界
		begin
			center = center - 1;
			if (alreadyShoot==0)
			begin
				state[center][6]=1;
				stateR[center][6]=0;
				stateG[center][6]=0;
				stateB[center][6]=1;
				state[center+1][6]=0;
				stateR[center+1][6]=0;
				stateG[center+1][6]=0;
				stateB[center+1][6]=0;
				ball_x = ball_x - 1;
			end		
			state[center-1][7]=1;
			stateR[center-1][7]=0;
			stateG[center-1][7]=0;
			stateB[center-1][7]=1;
			state[center+2][7]=0;
			stateR[center+2][7]=0;
			stateG[center+2][7]=0;
			stateB[center+2][7]=0;
		end
	end
	
	if (Right)	//底板右移
	begin
		if (center+2 <= 7)	//防超出邊界
		begin
			center = center + 1;
			if (alreadyShoot==0)
			begin
				state[center][6]=1;
				stateR[center][6]=0;
				stateG[center][6]=0;
				stateB[center][6]=1;
				state[center-1][6]=0;
				stateR[center-1][6]=0;
				stateG[center-1][6]=0;
				stateB[center-1][6]=0;
				ball_x = ball_x + 1;
			end
			state[center+1][7]=1;
			stateR[center+1][7]=0;
			stateG[center+1][7]=0;
			stateB[center+1][7]=1;
			state[center-2][7]=0;
			stateR[center-2][7]=0;
			stateG[center-2][7]=0;
			stateB[center-2][7]=0;
		end
	end
		
	if (shoot)	//發射按鈕
	begin
		state[ball_x][ball_y] = 0;
		stateR[ball_x][ball_y] = 0;
		stateG[ball_x][ball_y] = 0;
		stateB[ball_x][ball_y] = 0;
		alreadyShoot = 1;
		mode = 11;
	end	
		
	if (alreadyShoot)	//按發射alreadyshoot=1跑這段
	begin
		case(mode)	//六種形式:直上 左上 右上 直下 左下 右下
		11:     //直上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			ball_y = ball_y - 1;
			if (state[ball_x][ball_y]==1&&ball_y>=0)	//邊界內且碰到磚塊
			begin
			   point=point+1;
				ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;	
				mode = 21;	//反彈->直下
				if (state[ball_x][ball_y-2]==1)
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else if(ball_y<0)	//碰到上邊界
			begin
			   ball_y = ball_y + 2;
				state[ball_x][ball_y] = 1;	
				stateR[ball_x][ball_y] = 1;	
				stateG[ball_x][ball_y] = 1;	
				stateB[ball_x][ball_y] = 1;	
				mode = 21;	//反彈->直下
				if (state[ball_x][ball_y-2]==1)
				begin
					state[ball_x][ball_y-2] = 0;
					stateR[ball_x][ball_y-2] = 0;
					stateG[ball_x][ball_y-2] = 0;
					stateB[ball_x][ball_y-2] = 0;
				end
			end
			else
			begin
				state[ball_x][ball_y] = 1;
				stateR[ball_x][ball_y] = 1;
				stateG[ball_x][ball_y] = 1;
				stateB[ball_x][ball_y] = 1;
			end
		end
		12:     //左上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==0||ball_y==0)	//左邊界或上邊界
			begin
			   if(ball_x==0&&ball_y==0)	//左上的角
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode= 23;	//反彈->右下
				end
				else if(ball_x==0)	//左邊界
				begin
					if(state[ball_x+1][ball_y-1]==1)	//左上行進碰到左邊界且右上為磚塊
					begin
						state[ball_x+1][ball_y-1]=0;
						stateR[ball_x+1][ball_y-1]=0;
						stateG[ball_x+1][ball_y-1]=0;
						stateB[ball_x+1][ball_y-1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=23;	//反彈->右下
					end
				   else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=13;	//反彈->右上
					end
				end
				else
				begin
					ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=22;	//反彈->左下
				end			
			end
			else
			begin
				if(state[ball_x-1][ball_y-1]==1)	//打到磚塊
				begin
				   state[ball_x-1][ball_y-1]=0;
					stateR[ball_x-1][ball_y-1]=0;
					stateG[ball_x-1][ball_y-1]=0;
					stateB[ball_x-1][ball_y-1]=0;
					point=point+1;
					mode=23;	//反彈->右下
				end
				else
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=12;	//反彈->左上
				end
			end
		end
		13:     //右上
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_x==7||ball_y==0)	//右邊界或上邊界
			begin
			   if(ball_x==7&&ball_y==0)	//右上的角
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode= 22;	//反彈->左下
				end
				else if(ball_x==7)	//右邊界
				begin
					if(state[ball_x-1][ball_y-1]==1)	//右上行進碰到右邊界且左上為磚塊
					begin
						state[ball_x-1][ball_y-1]=0;
						stateR[ball_x-1][ball_y-1]=0;
						stateG[ball_x-1][ball_y-1]=0;
						stateB[ball_x-1][ball_y-1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=22;	//反彈->左下
					end
				   else
					begin
						ball_x=ball_x-1;
						ball_y=ball_y-1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=12;	//反彈->左上
					end
				end
				else	//上邊界
				begin
					ball_x=ball_x+1;
					ball_y=ball_y+1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					state[ball_x][ball_y]=1;
					mode=23;	//反彈->右下
				end			
			end
			else	//沒有打到邊界們
			begin
				if(state[ball_x+1][ball_y-1]==1)	//打到磚塊
				begin
					state[ball_x+1][ball_y-1]=0;
					stateR[ball_x+1][ball_y-1]=0;
					stateG[ball_x+1][ball_y-1]=0;
					stateB[ball_x+1][ball_y-1]=0;
					point=point+1;
					mode=22;	//反彈->左下
				end
				else	//持續右上
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y-1;
					state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=13;	//反彈->右上
				end
			end
		end
		21:	//直下
		begin
			state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if (ball_y==6 && ball_x >= center-1 && ball_x <= center+1)    //打到平台
			begin
				ball_y = ball_y - 1;
				if (ball_x == center)	//打到平台中間
				begin
					mode = 11;	//反彈->直上
					state[ball_x][ball_y] = 1;
					stateR[ball_x][ball_y] = 1;
					stateG[ball_x][ball_y] = 1;
					stateB[ball_x][ball_y] = 1;
				end
				else //左或右                         
				begin
					if (ball_x == center-1)  //打到平台左邊
					begin
						mode = 12;	//反彈->左上
						if (ball_x-1 < 0)	//左邊界
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
							mode = 13;	//反彈->右上
						end
						else	//一直左上
						begin
							ball_x = ball_x - 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
					else	//打到平台右邊
					begin
						mode = 13;	//反彈->右上
						if (ball_x + 1 > 7)//右邊界
						begin
							ball_x = ball_x - 1;
							mode = 12;	//反彈->左上
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
						   stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
						else	//一直右上
						begin
							ball_x = ball_x + 1;
							state[ball_x][ball_y] = 1;
							stateR[ball_x][ball_y] = 1;
							stateG[ball_x][ball_y] = 1;
							stateB[ball_x][ball_y] = 1;
						end
					end
				end
			end
			else	//沒有打到平台
			begin
				if (ball_y==7)	//掉下去紅色X出現
				begin
					state[0] = 8'b10000001;
					state[1] = 8'b01000010;
					state[2] = 8'b00100100;
					state[3] = 8'b00011000;
					state[4] = 8'b00011000;
					state[5] = 8'b00100100;
					state[6] = 8'b01000010;
					state[7] = 8'b10000001;
			
					stateR[0] = 8'b10000001;
					stateR[1] = 8'b01000010;
					stateR[2] = 8'b00100100;
					stateR[3] = 8'b00011000;
					stateR[4] = 8'b00011000;
					stateR[5] = 8'b00100100;
					stateR[6] = 8'b01000010;
					stateR[7] = 8'b10000001;
					
					stateG[0] = 8'b00000000;
					stateG[1] = 8'b00000000;
					stateG[2] = 8'b00000000;
					stateG[3] = 8'b00000000;
					stateG[4] = 8'b00000000;
					stateG[5] = 8'b00000000;
					stateG[6] = 8'b00000000;
					stateG[7] = 8'b00000000;
					
					stateB[0] = 8'b00000000;
					stateB[1] = 8'b00000000;
					stateB[2] = 8'b00000000;
					stateB[3] = 8'b00000000;
					stateB[4] = 8'b00000000;
					stateB[5] = 8'b00000000;
					stateB[6] = 8'b00000000;
					stateB[7] = 8'b00000000;
					
					win<=8'b00000000;	//得分歸零
					round=0;
					center = 1;
					alreadyShoot = 0;
					ball_x = 1;
					ball_y = 6;
					mode = 11;
					point=0;
				end
				else	//一直往下
				begin
					if(state[ball_x][ball_y+1] == 1)
					begin
						state[ball_x][ball_y+1] = 0;
						stateR[ball_x][ball_y+1] = 0;
						stateG[ball_x][ball_y+1] = 0;
						stateB[ball_x][ball_y+1] = 0;
						point=point+1;
						ball_y = ball_y - 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
						mode=11;	//反彈->直上
					end
					else
					begin
						ball_y = ball_y + 1;
						state[ball_x][ball_y] = 1;
						stateR[ball_x][ball_y] = 1;
						stateG[ball_x][ball_y] = 1;
						stateB[ball_x][ball_y] = 1;
					end
				end
			end
		end
		22:      //左下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if(ball_y==7)	//失敗紅色x出現
			begin
			   state[0] = 8'b10000001;
				state[1] = 8'b01000010;
				state[2] = 8'b00100100;
				state[3] = 8'b00011000;
				state[4] = 8'b00011000;
				state[5] = 8'b00100100;
				state[6] = 8'b01000010;
				state[7] = 8'b10000001;
			
			   stateR[0] = 8'b10000001;
				stateR[1] = 8'b01000010;
				stateR[2] = 8'b00100100;
				stateR[3] = 8'b00011000;
				stateR[4] = 8'b00011000;
				stateR[5] = 8'b00100100;
				stateR[6] = 8'b01000010;
				stateR[7] = 8'b10000001;
					
				stateG[0] = 8'b00000000;
				stateG[1] = 8'b00000000;
				stateG[2] = 8'b00000000;
				stateG[3] = 8'b00000000;
				stateG[4] = 8'b00000000;
				stateG[5] = 8'b00000000;
				stateG[6] = 8'b00000000;
				stateG[7] = 8'b00000000;
					
				stateB[0] = 8'b00000000;
				stateB[1] = 8'b00000000;
				stateB[2] = 8'b00000000;
				stateB[3] = 8'b00000000;
				stateB[4] = 8'b00000000;
				stateB[5] = 8'b00000000;
				stateB[6] = 8'b00000000;
				stateB[7] = 8'b00000000;
				win<=8'b00000000;	//得分歸零
				round=0;
				center = 1;
				alreadyShoot = 0;
				ball_x = 1;
				ball_y = 6;
				mode = 11;
				point=0;
			end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==center||ball_x==center+1||ball_x==center-1))	//打到板子
					begin
						if(ball_x==center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=11;	//反彈->直上
						end
						else if(ball_x==center-1)	//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=12;	//反彈->左上
						end
						else	//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=13;	//反彈->右上
						end
					end
					else
					begin//y+1
						ball_x=ball_x-1;
						ball_y=ball_y+1;				
					end
				end
				else if(ball_x==0)	//左邊界
				begin
				   if(state[ball_x+1][ball_y+1]==1)	//左下行進碰到左邊界且右下為磚塊
					begin
					   state[ball_x+1][ball_y+1]=0;
						stateR[ball_x+1][ball_y+1]=0;
						stateG[ball_x+1][ball_y+1]=0;
						stateB[ball_x+1][ball_y+1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=13;	//反彈->右上
					end
					else
					begin
						ball_x=ball_x+1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=23;	//反彈->右下
					end
				end
				else if(state[ball_x-1][ball_y+1]==1)	//打到磚塊
				begin
				   state[ball_x-1][ball_y+1]=0;
					stateR[ball_x-1][ball_y+1]=0;
					stateG[ball_x-1][ball_y+1]=0;
					stateB[ball_x-1][ball_y+1]=0;
					point=point+1;
					ball_x=ball_x+1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=13;	//反彈->右上
				end
				else	//持續左下
				begin
				   ball_x=ball_x-1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=22;	//反彈->左下
				end
			end
		end
		23:      //右下
		begin
		   state[ball_x][ball_y] = 0;
			stateR[ball_x][ball_y] = 0;
			stateG[ball_x][ball_y] = 0;
			stateB[ball_x][ball_y] = 0;
			if(ball_y==7)	//失敗紅色x出現
			begin
			   state[0] = 8'b10000001;
				state[1] = 8'b01000010;
				state[2] = 8'b00100100;
				state[3] = 8'b00011000;
				state[4] = 8'b00011000;
				state[5] = 8'b00100100;
				state[6] = 8'b01000010;
				state[7] = 8'b10000001;
				
				
			   stateR[0] = 8'b10000001;
				stateR[1] = 8'b01000010;
				stateR[2] = 8'b00100100;
				stateR[3] = 8'b00011000;
				stateR[4] = 8'b00011000;
				stateR[5] = 8'b00100100;
				stateR[6] = 8'b01000010;
				stateR[7] = 8'b10000001;
					
				stateG[0] = 8'b00000000;
				stateG[1] = 8'b00000000;
				stateG[2] = 8'b00000000;
				stateG[3] = 8'b00000000;
				stateG[4] = 8'b00000000;
				stateG[5] = 8'b00000000;
				stateG[6] = 8'b00000000;
				stateG[7] = 8'b00000000;
					
				stateB[0] = 8'b00000000;
				stateB[1] = 8'b00000000;
				stateB[2] = 8'b00000000;
				stateB[3] = 8'b00000000;
				stateB[4] = 8'b00000000;
				stateB[5] = 8'b00000000;
				stateB[6] = 8'b00000000;
				stateB[7] = 8'b00000000;
				win<=8'b00000000;	//得分歸零
				round=0;
				center = 1;
				alreadyShoot = 0;
				ball_x = 1;
				ball_y = 6;
				mode = 11;
				point=0;
			end
			else
			begin
			   if(ball_y==6)
				begin
					if((ball_x==center||ball_x==center+1||ball_x==center-1))	//打到板子
					begin
						if(ball_x==center)
						begin
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=11;	//反彈->直上
						end
						else if(ball_x==center-1)	//打到底板左邊
						begin
							ball_x=ball_x-1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=12;	//反彈->左上
						end
						else	//打到底板右邊
						begin
							ball_x=ball_x+1;
							ball_y=ball_y-1;
							state[ball_x][ball_y]=1;
							stateR[ball_x][ball_y]=1;
							stateG[ball_x][ball_y]=1;
							stateB[ball_x][ball_y]=1;
							mode=13;	//反彈->右上
						end
					end
					else
					begin	//y+1
						ball_x=ball_x+1;
						ball_y=ball_y+1;
					end
				end
				else if(ball_x==7)	//右邊界
				begin
				   if(state[ball_x-1][ball_y+1]==1)	//右下行進碰到右邊界且左下為磚塊
					begin
					   state[ball_x-1][ball_y+1]=0;
						stateR[ball_x-1][ball_y+1]=0;
						stateG[ball_x-1][ball_y+1]=0;
						stateB[ball_x-1][ball_y+1]=0;
						point=point+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=12;	//反彈->左上
					end
					else
					begin	//持續左上
						ball_x=ball_x-1;
						ball_y=ball_y+1;
						state[ball_x][ball_y]=1;
						stateR[ball_x][ball_y]=1;
						stateG[ball_x][ball_y]=1;
						stateB[ball_x][ball_y]=1;
						mode=22;	//反彈->左下
					end
				end
				else if(state[ball_x+1][ball_y+1]==1)	//打到磚塊
				begin
				   state[ball_x+1][ball_y+1]=0;
					stateR[ball_x+1][ball_y+1]=0;
					stateG[ball_x+1][ball_y+1]=0;
					stateB[ball_x+1][ball_y+1]=0;
					point=point+1;
					ball_x=ball_x-1;
					ball_y=ball_y-1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=12;	//反彈->左上
				end
				else	//持續右下
				begin
				   ball_x=ball_x+1;
					ball_y=ball_y+1;
				   state[ball_x][ball_y]=1;
					stateR[ball_x][ball_y]=1;
					stateG[ball_x][ball_y]=1;
					stateB[ball_x][ball_y]=1;
					mode=23;	//反彈->右下
				end
			end
		end	
		endcase	//6
   end	//begin alreadyShoot
  end
end

always @(posedge CLK_div)
begin
	Col = Col + 1;
end
assign EN=1;
assign lightRed = ~stateR[Col];
assign lightGreen = ~stateG[Col];
assign lightBlue = ~stateB[Col];

endmodule

