`timescale 1ns / 1ps

// TextLCD      
module textlcd(
	input		RESET,			// nRESET input
	input		CLK,				// CLOCK input
	output wire	LCD_RS,		// register selector
	output wire	LCD_RW,		// READ or nWRITE
	output reg	LCD_EN,		// LCD TEXT Enable
	output wire	[7:0]	LCD_DATA,
	input		[3:0]	LEFT_KEY,
	input Mode_Switch
);

reg	[31:0] 	cnt;		//prescaler1
reg	[2:0]		status;	//counter1
reg	[10:0]	delay_lcdclk;	//prescaler2
reg	[5:0]		count_lcd;		//counter2

reg	[127:0] 	line_1;
reg	[127:0] 	line_2;
reg 	[8:0] 	set_data;

reg LEFT_K0;
reg LEFT_K1;
reg LEFT_K2;
reg LEFT_K3;

reg Rec_on;
reg [26:0] Rec_cnt;
reg		[26:0] Rec_wait;
reg		Rec_start;



always @ (posedge CLK or posedge RESET)
begin
	if (RESET)
		cnt <= 25'd0;
	else
		begin
			if (cnt < 25'd23999999)		
				cnt <= cnt + 25'd1;
			else
			   cnt <= 25'd0;
		end
end

always @ (posedge CLK or posedge RESET)
begin
	if (RESET)
		status <= 3'd0;
	else
		begin
			if (cnt == 25'd23999999)
			begin
				if(status == 3'd7)		
					status <= 3'd0;
				else
					status <= status + 3'd1;
			end
		end
end

always @(posedge RESET or posedge CLK)
begin
	if(RESET)
		begin
			delay_lcdclk	<=	11'd0;
			count_lcd		<=	6'd0; 
			LCD_EN		<=	1'b0;
			
			LEFT_K0 <= 0;
			LEFT_K1 <= 0;
			LEFT_K2 <= 0;
			LEFT_K3 <= 0;
			line_1	<= {"Select LEFT_KEY "};
			line_2	<= {"1Fre2REC3BK24BK1"};
			
			Rec_on <=0;
			Rec_cnt <=27'd0;
			Rec_wait <= 27'd0;
			Rec_start <=0;
		end
	else
		begin
			if (delay_lcdclk < 11'd2000)
				delay_lcdclk <=  delay_lcdclk + 11'd1;
			else
				delay_lcdclk <= 11'd0;

			if (delay_lcdclk == 11'd0)
				begin
					if (count_lcd < 6'd40)
						count_lcd <= count_lcd + 6'd1;
					else
						count_lcd <= 6'd7;
				end

			if (delay_lcdclk == 11'd200)
				LCD_EN <= 1'b1;
			else if (delay_lcdclk == 11'd1800)
				LCD_EN <= 1'b0;
			//////////////////////////////////////////////////////
			if(LEFT_KEY[0]==1) begin
				LEFT_K0<=1;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=0;
				Rec_on<= 0;
			   Rec_start <=0; end
			else if(LEFT_KEY[1]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=1;
				LEFT_K2<=0;
				LEFT_K3<=0;
				Rec_on<= 0;
			   Rec_start <=0; end	
			else if(LEFT_KEY[2]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=1;
				LEFT_K3<=0;end	
			else if(LEFT_KEY[3]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=1;
				Rec_on<= 0;
			   Rec_start <=0; end
			if(LEFT_K0==1)
				begin
					line_1 <= {"Mode Bank1      "};
					case(status)
						3'd0 : begin line_2 <= {"A Flightless Air"}; end
						3'd1 : begin line_2 <= {" Flightless Airp"}; end
						3'd2 : begin line_2 <= {"Flightless Airpl"}; end
						3'd3 : begin line_2 <= {"lightless Airpla"}; end
						3'd4 : begin line_2 <= {"ightless Airplan"}; end
						3'd5 : begin line_2 <= {"ghtless Airplane"}; end
						3'd6 : begin line_2 <= {"htless Airplane "}; end
						3'd7 : begin line_2 <= {"tless Airplane  "}; end
					endcase
				end
			else if(LEFT_K1==1)
				begin line_1 <= {"Mode Bank2      "}; line_2 <= {"Toy Forest      "}; end
			else if(LEFT_K2==1)/////////////////////////////////////////////////////////////////////////////
			begin 
				if(LEFT_KEY[2]==1)
				begin
					if(Rec_on ==0)
					begin
							if(Rec_cnt >27'd71999999)
							begin
									Rec_on <=1;
									Rec_cnt<= 27'd0;
							end
							else	begin	Rec_cnt<= Rec_cnt+ 27'd1;	end
					end
				Rec_wait <=27'd0;	
				end
				
				else begin Rec_cnt<= 27'd0; end
				
				
				
				if((Rec_on==1) && (LEFT_KEY[2]==0))
				begin/////////////////////////////////////////////////////////
					if(Rec_wait>27'd71999999)
					begin
							Rec_start <=1;
							Rec_wait <=27'd0;
					end
					else begin Rec_wait <= Rec_wait + 27'd1; end
					
					
					if(Rec_start==1)
					begin
						begin line_1 <= {"Mode Record     "}; line_2 <= {"Recoding...     "}; end
					end
				end
			
				else
					begin line_1 <= {"Mode Record     "}; line_2 <= {"Stay push L_SW2 "}; end
					
			end	////////////////////////////////////////////////////////////////////////////////////
				
			else if(LEFT_K3==1)
			begin
				if(!Mode_Switch)
					begin line_1 <= {"Mode Free       "}; line_2 <= {"Scale scale     "}; end
				else
					begin line_1 <= {"Mode Free       "}; line_2 <= {"Scale Arpeggio  "}; end
			end		
	end
end

// TextLCD register 
initial
begin
	line_1	<= {"Select LEFT_KEY "};
	line_2	<= {"1Fre2REC3BK24BK1"};
end
/*
always @ (status)
begin
	case(status)	
		3'd0 : 	begin line_1 <= {"I'm KimSuHyun   "}; line_2 <= {"FPGA is very fun"}; end
		3'd2 : 	begin line_1 <= {"Hello world     "}; line_2 <= {"zzzzzzzzzzzzzzzz"}; end	
		3'd4 : 	begin line_1 <= {"world Hello     "}; line_2 <= {"aaaaaaaaaaaaaaaa"}; end	
		3'd6 : 	begin line_1 <= {"Hello world     "}; line_2 <= {"F P G A         "}; end	
		default: begin line_1 <= {"I'm KimSuHyun   "}; line_2 <= {"FPGA is very fun"}; end
	endcase
end*/

always @(posedge RESET or posedge CLK)
begin
	if (RESET)
		set_data <= 9'd0;
	else
		begin
			case (count_lcd)
				16'd0		:	set_data	<=	{1'b0, 8'h38};	//mode_pwron
				16'd1		:	set_data	<=	{1'b0, 8'h38};	//mode_fnset
				16'd2		:	set_data	<=	{1'b0, 8'h0e}; //mode_onoff;
				16'd3		:	set_data	<=	{1'b0, 8'h06}; //mode_entr1;
				16'd4		:	set_data	<=	{1'b0, 8'h02};	//mode_entr2;
				16'd5		:	set_data	<=	{1'b0, 8'h01};	//mode_entr3;
				16'd6		:	set_data	<=	{1'b0, 8'h80};	//mode_seta1;
				16'd7		:	set_data	<=	{1'b1, line_1[127:120]};
				16'd8		:	set_data	<=	{1'b1, line_1[119:112]};
				16'd9		:	set_data	<=	{1'b1, line_1[111:104]};
				16'd10	:	set_data	<=	{1'b1, line_1[103:96]};
				16'd11	:	set_data	<=	{1'b1, line_1[95:88]};
				16'd12	:	set_data	<=	{1'b1, line_1[87:80]};
				16'd13	:	set_data	<=	{1'b1, line_1[79:72]};
				16'd14	:	set_data	<=	{1'b1, line_1[71:64]};
				16'd15	:	set_data	<=	{1'b1, line_1[63:56]};
				16'd16	:	set_data	<=	{1'b1, line_1[55:48]};
				16'd17	:	set_data	<=	{1'b1, line_1[47:40]};
				16'd18	:	set_data	<=	{1'b1, line_1[39:32]};
				16'd19	:	set_data	<=	{1'b1, line_1[31:24]};
				16'd20	:	set_data	<=	{1'b1, line_1[23:16]};
				16'd21	:	set_data	<=	{1'b1, line_1[15:8]};
				16'd22	:	set_data	<=	{1'b1, line_1[7:0]};
				16'd23	:	set_data	<=	{1'b0, 8'hc0};		//mode_seta2;
				16'd24	:	set_data	<=	{1'b1, line_2[127:120]};	
				16'd25	:	set_data	<=	{1'b1, line_2[119:112]};
				16'd26	:	set_data	<=	{1'b1, line_2[111:104]};
				16'd27	:	set_data	<=	{1'b1, line_2[103:96]};
				16'd28	:	set_data	<=	{1'b1, line_2[95:88]};	
				16'd29	:	set_data	<=	{1'b1, line_2[87:80]};
				16'd30	:	set_data	<=	{1'b1, line_2[79:72]};
				16'd31	:	set_data	<=	{1'b1, line_2[71:64]};
				16'd32	:	set_data	<=	{1'b1, line_2[63:56]};	
				16'd33	:	set_data	<=	{1'b1, line_2[55:48]};
				16'd34	:	set_data	<=	{1'b1, line_2[47:40]};
				16'd35	:	set_data	<=	{1'b1, line_2[39:32]};
				16'd36	:	set_data	<=	{1'b1, line_2[31:24]};	
				16'd37	:	set_data	<=	{1'b1, line_2[23:16]};
				16'd38	:	set_data	<=	{1'b1, line_2[15:8]};
				16'd39	:	set_data	<=	{1'b1, line_2[7:0]};
				16'd40	:	set_data	<=	{1'b0, 8'h02};	//mode_delay;
				16'd41	:	set_data	<=	{1'b0, 8'h02};	//mode_actcm;
				default	:	begin end
			endcase
		end
end

assign LCD_RS = set_data[8];
assign LCD_RW = 1'b0;
assign LCD_DATA = set_data[7:0];

endmodule
