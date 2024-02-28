`timescale 1ns / 1ps

module dot(
	input RESET,
	input CLK,
	output [9:0] DOT_COL,
	output [13:0] DOT_RAW,
	
	input[8:0] KEY,
	input Mode_Switch,
	input		[3:0]	LEFT_KEY
);

reg [12:0]	cnt;
reg [7:0]	COL_counter;

reg [24:0] 	DOT_Data_counter;
//reg [3:0] 	DOT_Data;

reg [9:0]	dot_COL_reg;
reg [6:0]	dot_raw_reg;

reg [24:0]  Dot_raw_counter;
reg [7:0]   Dot_raw0;
reg [10:0]  Dot_COL0;
reg [7:0]   Dot_raw1;
reg [10:0]  Dot_COL1;
reg [7:0]   Dot_raw2;
reg [10:0]  Dot_COL2;
reg [7:0]   Dot_raw3;
reg [10:0]  Dot_COL3;
reg [7:0]   Dot_raw4; reg[7:0] Dot_raw4_1; reg[7:0] Dot_raw4_2; reg[7:0] Dot_raw4_3; reg[7:0] Dot_raw4_4;
reg [10:0]  Dot_COL4;
reg [7:0]   Dot_raw5;
reg [10:0]  Dot_COL5;
reg [7:0]   Dot_raw6;
reg [10:0]  Dot_COL6;
reg [7:0]   Dot_raw7;
reg [10:0]  Dot_COL7;
reg [7:0]   Dot_raw8;
reg [10:0]  Dot_COL8;
reg n0;	reg n1;	reg n2;	reg n3;	reg n4;	reg n5;	reg n6;	reg n7;	reg n8;
reg c0;	reg c1;	reg c2;	reg c3;	reg c4;	reg c5;	reg c6;	reg c7;	reg c8;
reg [4:0] n4_b;
reg SW[8:0];
reg LEFT_K0;
reg LEFT_K1;
reg LEFT_K2;
reg LEFT_K3;
reg [25:0] cnt_K1;
reg [24:0] cnt_K3;
reg cnt_K3_on;

reg Rec_on;
reg [26:0] Rec_cnt;
reg		[26:0] Rec_wait;
reg [2:0] Rec_start_sec;


always @ (posedge RESET or posedge CLK)
begin
	if (RESET)
		begin
			cnt <= 13'd0;
		end
	else
		begin
			if (cnt < 13'd5999)
				cnt <= cnt + 13'd1;
			else
				cnt <= 13'd0;
		end
end
   
always @ (posedge RESET or posedge CLK)
begin
	if (RESET)
		COL_counter <=8'd0;
	else
		if (cnt > 13'd5998)
			if(COL_counter > 8'd89)
				COL_counter <=8'd0;
			else
				COL_counter <= COL_counter + 1'b1;
end

always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		DOT_Data_counter <=25'd0;
	else
		if(DOT_Data_counter < 25'd23999999)
			DOT_Data_counter <= DOT_Data_counter + 25'd1;
		else
			DOT_Data_counter <= 25'd0;
end
/*
always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		cnt_K3 <=2'd0;
	else
		if(DOT_Data_counter == 25'd23999999)
			if(cnt_K3 == 2'd2 && cnt_K3_on ==1)
				cnt_K3 <= 2'd0;
				cnt_K3_on <=0;
			else
				cnt_K3 <= cnt_K3 + 2'd1;
				cnt_K3_on <=1;
end*/
//////////////////////////////////////////////
always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		Dot_raw_counter <=25'd0;
	else
		if(Dot_raw_counter < 25'd4799999)
			Dot_raw_counter <= Dot_raw_counter + 25'd1;
		else
			Dot_raw_counter <= 25'd0;
end

always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
	begin
		Dot_raw0<=8'b0;	Dot_raw1<=8'b0;		Dot_raw2<=8'b0;		Dot_raw3<=8'b0;		Dot_raw4<=8'b0;	Dot_raw4_1<=8'b0; Dot_raw4_2<=8'b0; Dot_raw4_3<=8'b0; Dot_raw4_4<=8'b0;
		Dot_raw5<=8'b0;	Dot_raw6<=8'b0;		Dot_raw7<=8'b0;		Dot_raw8<=8'b0;	
		Dot_COL0<=11'b0;	Dot_COL1<=11'b0;		Dot_COL2<=11'b0;		Dot_COL3<=11'b0;		Dot_COL4<=11'b0;
		Dot_COL5<=11'b0;	Dot_COL6<=11'b0;		Dot_COL7<=11'b0;		Dot_COL8<=11'b0;
		n0<=0;	n1<=0;	n2<=0;	n3<=0;	n4<=0;	n5<=0;	n6<=0;	n7<=0;	n8<=0;	
		c0<=0;	c1<=0;	c2<=0;	c3<=0;	c4<=0;	c5<=0;	c6<=0;	c7<=0;	c8<=0;
		n4_b<=5'd0;
		LEFT_K0 <= 0;
		LEFT_K1 <= 0;
		LEFT_K2 <= 0;
		LEFT_K3 <= 0;
		cnt_K3 <=25'd0;
		cnt_K3_on <=0;
		cnt_K1 <=26'd0;
		
		Rec_on <=0;
		Rec_cnt <=27'd0;
		Rec_wait <= 27'd0;
		Rec_start_sec <=3'd0;
		
		
	end
	else begin
		if(LEFT_KEY[0]==1) begin
				LEFT_K0<=1;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=0;
				Rec_on<= 0;
				Rec_start_sec <=3'd0;				
				end
			else if(LEFT_KEY[1]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=1;
				LEFT_K2<=0;
				LEFT_K3<=0;
				Rec_on<= 0;
				Rec_start_sec <=3'd0;
				end	
			else if(LEFT_KEY[2]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=1;
				LEFT_K3<=0;
				SW[8]<=0;
				end	
			else if(LEFT_KEY[3]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=1;
				Rec_on<= 0;
				Rec_start_sec <=3'd0;
				end
		if(LEFT_K0==1)////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		begin
			if(KEY[0] == 1)
			begin
				Dot_raw0<=8'b0;
				Dot_COL0<=11'b0;
				n0<=1;
				c0<=1;
				SW[0]<=1;
				
			end
			
			if(KEY[1] == 1)
			begin
				Dot_raw1<=8'b0;
				Dot_COL1<=11'b0;
				n1<=1;
				c1<=1;
				SW[1]<=1; 		
			end
			
			if(KEY[2] == 1)
			begin
				Dot_raw2<=8'b0;
				Dot_COL2<=11'b0;
				n2<=1;
				c2<=1;
				SW[2]<=1; 
			end

			if(KEY[3] == 1)
			begin
				Dot_raw3<=8'b0;
				Dot_COL3<=11'b0;
				n3<=1;
				c3<=1;
				SW[3]<=1; 
			end

			if(KEY[4] == 1)
			begin
				Dot_raw4<=8'b0;
				Dot_raw4_1 <=8'b0;
				Dot_raw4_2 <=8'b0;
				Dot_raw4_3 <=8'b0;
				Dot_raw4_4 <=8'b0;
				Dot_COL4<=11'b0;
				n4_b<= 5'd0;
				n4<=1;
				c4<=1;
				SW[4]<=1; 
			end
			
			if(KEY[5] == 1)
			begin
				Dot_raw5<=8'b0;
				Dot_COL5<=11'b0;
				n5<=1;
				c5<=1;
				SW[5]<=1; 
			end		
			
			if(KEY[6] == 1)
			begin
				Dot_raw6<=8'b0;
				Dot_COL6<=11'b0;
				n6<=1;
				c6<=1;
				SW[6]<=1; 
			end	

			if(KEY[7] == 1)
			begin
				Dot_raw7<=8'b0;
				Dot_COL7<=11'b0;
				n7<=1;
				c7<=1;
				SW[7]<=1; 		
			end
			
			if(KEY[8] == 1)
			begin
				Dot_raw8<=8'b0;
				Dot_COL8<=11'b0;
				n8<=1;
				c8<=1;
				SW[8]<=1; 
			end		
	//////////////////////////////////////////////////		
			if(Dot_raw_counter == 25'd4799999)
			begin
				if(n0==1)
				begin
					if(Dot_raw0 == 8'b00000000)
						Dot_raw0 <= 8'b10000000;
					else 
						Dot_raw0 <= (Dot_raw0>>1);
					if(Dot_raw0 == 8'b00000001)
						n0<=0;                        //end
				end
				if(c0==1)
				begin
					if(Dot_COL0 == 11'b00000000000)
						Dot_COL0 <= 11'b00000000001;
					else
						Dot_COL0 <= (Dot_COL0<<1);
					if(Dot_COL0 == 11'b10000000000)
						c0<=0;
				end
				///////////////////////////
				if(n1==1)
				begin
					if(Dot_raw1 == 8'b00000000)
						Dot_raw1 <= 8'b11111111;
					else
						Dot_raw1 <= 8'b11111111;
				end
				if(c1==1)
				begin
					if(Dot_COL1 == 11'b00000000000)
						Dot_COL1 <= 11'b00000000001;
					else
						Dot_COL1 <= (Dot_COL1<<1)+1'b1;
					if(Dot_COL1 == 11'b11111111111)begin
						c1<=0;
						Dot_COL1 <= 11'b00000000000;
						end
				end
				//////////////////////////////////
				if(n2==1)
				begin
					if(Dot_raw2 == 8'b00000000)
						Dot_raw2 <= 8'b00000001;
					else 
						Dot_raw2 <= (Dot_raw2<<1);
					if(Dot_raw2 == 8'b10000000)
						n2<=0;                        //end
				end
				if(c2==1)
				begin
					if(Dot_COL2 == 11'b00000000000)
						Dot_COL2 <= 11'b00000000001;
					else
						Dot_COL2 <= (Dot_COL2<<1);
					if(Dot_COL2 == 11'b10000000000)
						c2<=0;
				end		
				/////////////////////////////
				if(n3==1)
				begin
					if(Dot_raw3 == 8'b00000000)
						Dot_raw3 <= 8'b10000000;
					else
						Dot_raw3 <= (Dot_raw3>>1);
					if(Dot_raw3 == 8'b00000001)
						n3<=0;
				end
				if(c3==1)
				begin
					if(Dot_COL3 == 11'b00000000000)
						Dot_COL3 <= 11'b11111111111;
					else
						Dot_COL3 <= 11'b11111111111;
				end
				///////////////////////////////
				if(n4==1)
				begin
				
					if (n4_b > 5'd0  &&	n4_b<5'd31)
					begin
							Dot_raw4 <=~(Dot_raw4); 
							Dot_raw4_1 <=~(Dot_raw4_1);
							Dot_raw4_2 <=~(Dot_raw4_2);
							Dot_raw4_3 <=~(Dot_raw4_3);
							Dot_raw4_4 <=~(Dot_raw4_4);
							n4_b <= n4_b + 5'd1;
					end
					else if(n4_b==5'd31)
					begin
							n4_b <=5'd0;
							n4<=0;
					end
					else if(Dot_raw4 == 8'b00000000)
							Dot_raw4 <= 8'b00001000;
					else if(Dot_raw4 == 8'b00001000)
					begin
							Dot_raw4 <= 8'b00011100;
							Dot_raw4_1 <=8'b00011100;
					end
					else if(Dot_raw4 == 8'b00011100)
					begin
							Dot_raw4 <= 8'b00111110;
							Dot_raw4_1 <=8'b00111110;	
							Dot_raw4_2 <=8'b00111110;					
					end
					else if(Dot_raw4 == 8'b00111110)
					begin
							Dot_raw4 <= 8'b01111111;
							Dot_raw4_1 <=8'b01111111;	
							Dot_raw4_2 <=8'b01111111;	
							Dot_raw4_3 <=8'b01111111;						
					end
					else if(Dot_raw4 == 8'b01111111)
					begin
							Dot_raw4 <= 8'b11111111;
							Dot_raw4_1 <=8'b11111111;	
							Dot_raw4_2 <=8'b11111111;	
							Dot_raw4_3 <=8'b11111111;
							Dot_raw4_4 <=8'b01111111;						
					end
					else if(Dot_raw4 ==8'b11111111)
					begin
							Dot_raw4 <=8'b00000000; 
							Dot_raw4_1 <=8'b00000000;
							Dot_raw4_2 <=8'b00000000;
							Dot_raw4_3 <=8'b00000000;
							Dot_raw4_4 <=8'b00000000;		
							n4_b <= n4_b + 5'd1;
					end				
				end
				///////////////////////////////
				if(n5==1)
				begin
					if(Dot_raw5 == 8'b00000000)
						Dot_raw5 <= 8'b00000001;
					else
						Dot_raw5 <= (Dot_raw5<<1);
					if(Dot_raw5 == 8'b10000000)
						n5<=0;
				end
				if(c5==1)
				begin
					if(Dot_COL5 == 11'b00000000000)
						Dot_COL5 <= 11'b11111111111;
					else
						Dot_COL5 <= 11'b11111111111;
				end
				///////////////////////////////////////
				if(n6==1)
				begin
					if(Dot_raw6 == 8'b00000000)
						Dot_raw6 <= 8'b10000000;
					else
						Dot_raw6 <= (Dot_raw6>>1);
					if(Dot_raw6 == 8'b00000001)
						n6<=0;
				end
				if(c6==1)
				begin
					if(Dot_COL6 == 11'b00000000000)
						Dot_COL6 <= 11'b10000000000;
					else
						Dot_COL6 <= (Dot_COL6>>1);
					if(Dot_COL6 == 11'b00000000001)	
						c6<=0;
				end
				/////////////////////////////////////
				if(n7==1)
				begin
					if(Dot_raw7 == 8'b00000000)
						Dot_raw7 <= 8'b11111111;
					else
						Dot_raw7 <= 8'b11111111;
				end
				if(c7==1)
				begin
					if(Dot_COL7 == 11'b00000000000)
						Dot_COL7 <= 11'b10000000000;
					else
						Dot_COL7 <= (Dot_COL7>>1)+11'b10000000000;
					if(Dot_COL7 == 11'b11111111111)
					begin
						c7<=0;
						Dot_COL7 <= 11'b00000000000;
					end
				end
				///////////////////////////////////////////////
				if(n8==1)
				begin
					if(Dot_raw8 == 8'b00000000)
						Dot_raw8 <= 8'b00000001;
					else
						Dot_raw8 <= (Dot_raw8<<1);
					if(Dot_raw8 == 8'b10000000)
						n8<=0;
				end
				if(c8==1)
				begin
					if(Dot_COL8 == 11'b00000000000)
						Dot_COL8 <= 11'b10000000000;
					else
						Dot_COL8 <= (Dot_COL8>>1);
					if(Dot_COL8 == 11'b00000000001)	
						c8<=0;
				end			
				///////////////////////////////////
			end
		end//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if(LEFT_K1==1)
		begin
			if(KEY[0] == 1)	begin SW[0]<= 1; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[1] == 1)	begin SW[0]<= 0; SW[1]<= 1; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[2] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 1; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[3] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 1; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[4] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 1; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[5] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 1; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[6] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 1; SW[7]<= 0; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[7] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 1; SW[8]<= 0; cnt_K1<= 26'd0; end
			if(KEY[8] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 1; cnt_K1<= 26'd0; end
			
			if(SW[0]==1)
			begin
				if(cnt_K1 > 26'd35999999)	begin	cnt_K1<= 26'd0;	SW[0]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[0]<=1;	end
			end
			
			else if(SW[1]==1)
			begin
				if(cnt_K1 > 26'd17999999)	begin	cnt_K1<= 26'd0;	SW[1]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[1]<=1;	end
			end

			else if(SW[2]==1)
			begin
				if(cnt_K1 > 26'd35999999)	begin	cnt_K1<= 26'd0;	SW[2]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[2]<=1;	end
			end

			else if(SW[3]==1)
			begin
				if(cnt_K1 > 26'd17999999)	begin	cnt_K1<= 26'd0;	SW[3]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[3]<=1;	end
			end

			else if(SW[4]==1)
			begin
				if(cnt_K1 > 26'd17999999)	begin	cnt_K1<= 26'd0;	SW[4]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[4]<=1;	end
			end

			else if(SW[5]==1)
			begin
				if(cnt_K1 > 26'd35999999)	begin	cnt_K1<= 26'd0;	SW[5]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[5]<=1;	end
				
			end

			else if(SW[6]==1)
			begin
				if(cnt_K1 > 26'd35999999)	begin	cnt_K1<= 26'd0;	SW[6]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[6]<=1;	end
			end

			else if(SW[7]==1)
			begin
				if(cnt_K1 > 26'd17999999)	begin	cnt_K1<= 26'd0;	SW[7]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[7]<=1;	end
			end

			else if(SW[8]==1)
			begin
				if(cnt_K1 > 26'd35999999)	begin	cnt_K1<= 26'd0;	SW[8]<=0;	end
				else	begin	cnt_K1 <=cnt_K1 + 26'd1;	SW[8]<=1;	end
			end
		
		
		
		
		end/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
					else if(LEFT_K2==1)
					begin
					
								if(LEFT_KEY[2]==1)
								begin
									if(Rec_on ==0)
									begin
												if(Rec_cnt >27'd71999999)
												begin
														Rec_on <=1;
														Rec_start_sec <= 3'd1;
														Rec_cnt<= 27'd0;
												end
												else	begin	Rec_cnt<= Rec_cnt+ 27'd1;	end
									end
									Rec_wait <=27'd0;	
								end
									
					else begin Rec_cnt<= 27'd0; end
				
				
					if((Rec_on==1) && (LEFT_KEY[2]==0))
					begin/////////////////////////////////////////////////////////
						if(Rec_start_sec <3'd4)
						begin
							if(Rec_wait>27'd23999999)
							begin
									Rec_start_sec <= Rec_start_sec + 3'd1;
									Rec_wait <=27'd0;
							end
							else begin Rec_wait <= Rec_wait + 27'd1; end
						end
					end
					
					if( Rec_start_sec == 3'd4)
					begin
						if(KEY[8])
							SW[8]<=1;
					end
				
		
		end//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if((LEFT_K3==1) && (Mode_Switch))
		begin
			if(KEY[0] == 1)	begin SW[0]<= 1; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[1] == 1)	begin SW[0]<= 0; SW[1]<= 1; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[2] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 1; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[3] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 1; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[4] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 1; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[5] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 1; SW[6]<= 0; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[6] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 1; SW[7]<= 0; SW[8]<= 0; end
			if(KEY[7] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 1; SW[8]<= 0; end
			if(KEY[8] == 1)	begin SW[0]<= 0; SW[1]<= 0; SW[2]<= 0; SW[3]<= 0; SW[4]<= 0; SW[5]<= 0; SW[6]<= 0; SW[7]<= 0; SW[8]<= 1; end
			
			if(KEY[0]==1 || KEY[1]==1 || KEY[2]==1 || KEY[3]==1 || KEY[4]==1 || KEY[5]==1 || KEY[6]==1 || KEY[7]==1 || KEY[8]==1)
			begin
				cnt_K3_on <=1;
				cnt_K3 <=25'd0;
			end
			
			if(cnt_K3_on ==1)
			begin
				if(cnt_K3 > 25'd47999999)
				begin
					cnt_K3 <= 25'd0;
					cnt_K3_on <=0;
				end
				else
				begin
					cnt_K3 <= cnt_K3+25'd1;
					cnt_K3_on <=1;	
				end
			end	
			
		end////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////		
	end
end


always @ (COL_counter)
begin
	if(RESET)
	begin
		dot_COL_reg<=10'b0000000000;
		dot_raw_reg<=7'b0000000;
	end
	else
	begin
		if(LEFT_K0==1)/////////////////////////////////////////////////////////////////////////////////////////////////
		begin
			if(SW[0] == 1)
			begin
					case(COL_counter)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{Dot_raw0[7:1]}; end
						8'd1	: begin dot_COL_reg <= Dot_COL0[9:0]; dot_raw_reg <= ~{7'b1000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd3	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd6	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd7	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			if(SW[1] == 1)
			begin
					case(COL_counter)
						8'd10	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd11	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd12	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd13	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd14	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd15	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd16	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd17	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd18	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
						8'd19	: begin dot_COL_reg <= Dot_COL1[9:0]; dot_raw_reg <= ~{7'b1111111}; end
					endcase
			end
			if(SW[2] == 1)
			begin
					case(COL_counter)
						8'd20	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{Dot_raw2[6:0]}; end
						8'd21	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{Dot_raw2[6:0]}; end
						8'd22	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{Dot_raw2[6:0]}; end
						8'd23	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{Dot_raw2[6:0]}; end
						8'd24	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd25	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd26	: begin dot_COL_reg <= Dot_COL2[9:0]; dot_raw_reg <= ~{7'b0000001}; end
						8'd27	: begin dot_COL_reg <= Dot_COL2[9:0]; dot_raw_reg <= ~{7'b0000001}; end
						8'd28	: begin dot_COL_reg <= Dot_COL2[9:0]; dot_raw_reg <= ~{7'b0000001}; end
						8'd29	: begin dot_COL_reg <= Dot_COL2[9:0]; dot_raw_reg <= ~{7'b0000001}; end
					endcase
			end
			if(SW[3] == 1)
			begin
					case(COL_counter)
						8'd30	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd31	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd32	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd33	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd34	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd35	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd36	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd37	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd38	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
						8'd39	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw3[7:1]}; end
					endcase
			end
			if(SW[4] == 1)
			begin
					case(COL_counter)
						8'd40	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw4_4[6:0]}; end
						8'd41	: begin dot_COL_reg <= 10'b0111111110; dot_raw_reg <= ~{Dot_raw4_3[6:0]}; end
						8'd42	: begin dot_COL_reg <= 10'b0011111100; dot_raw_reg <= ~{Dot_raw4_2[6:0]}; end
						8'd43	: begin dot_COL_reg <= 10'b0001111000; dot_raw_reg <= ~{Dot_raw4_1[6:0]}; end
						8'd44	: begin dot_COL_reg <= 10'b0000110000; dot_raw_reg <= ~{Dot_raw4[6:0]}; end
						8'd45	: begin dot_COL_reg <= 10'b0000110000; dot_raw_reg <= ~{Dot_raw4[6:0]}; end
						8'd46	: begin dot_COL_reg <= 10'b0001111000; dot_raw_reg <= ~{Dot_raw4_1[6:0]}; end
						8'd47	: begin dot_COL_reg <= 10'b0011111100; dot_raw_reg <= ~{Dot_raw4_2[6:0]}; end
						8'd48	: begin dot_COL_reg <= 10'b0111111110; dot_raw_reg <= ~{Dot_raw4_3[6:0]}; end
						8'd49	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw4_4[6:0]}; end
					endcase
			end
			if(SW[5] == 1)
			begin
					case(COL_counter)
						8'd50	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd51	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd52	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd53	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd54	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd55	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd56	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd57	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd58	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
						8'd59	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{Dot_raw5[6:0]}; end
					endcase
			end
			if(SW[6] == 1)
			begin
					case(COL_counter)
						8'd60	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw6[7:1]}; end
						8'd61	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw6[7:1]}; end
						8'd62	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw6[7:1]}; end
						8'd63	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw6[7:1]}; end
						8'd64	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd65	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd66	: begin dot_COL_reg <= Dot_COL6[10:1]; dot_raw_reg <= ~{7'b1000000}; end
						8'd67	: begin dot_COL_reg <= Dot_COL6[10:1]; dot_raw_reg <= ~{7'b1000000}; end
						8'd68	: begin dot_COL_reg <= Dot_COL6[10:1]; dot_raw_reg <= ~{7'b1000000}; end
						8'd69	: begin dot_COL_reg <= Dot_COL6[10:1]; dot_raw_reg <= ~{7'b1000000}; end
					endcase
			end
			if(SW[7] == 1)
			begin
					case(COL_counter)
						8'd70	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd71	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd72	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd73	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd74	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd75	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd76	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd77	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd78	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
						8'd79	: begin dot_COL_reg <= Dot_COL7[10:1]; dot_raw_reg <= ~{7'b1111111}; end
					endcase
			end		
			if(SW[8] == 1)
			begin
					case(COL_counter)
						8'd80	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw8[6:0]}; end
						8'd81	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw8[6:0]}; end
						8'd82	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw8[6:0]}; end
						8'd83	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{Dot_raw8[6:0]}; end
						8'd84	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd85	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd86	: begin dot_COL_reg <= Dot_COL8[10:1]; dot_raw_reg <= ~{7'b0000001}; end
						8'd87	: begin dot_COL_reg <= Dot_COL8[10:1]; dot_raw_reg <= ~{7'b0000001}; end
						8'd88	: begin dot_COL_reg <= Dot_COL8[10:1]; dot_raw_reg <= ~{7'b0000001}; end
						8'd89	: begin dot_COL_reg <= Dot_COL8[10:1]; dot_raw_reg <= ~{7'b0000001}; end
					endcase
			end
			else
			begin
				case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd1	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd3	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd6	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd7	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
				endcase
			end
		end/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if(LEFT_K1==1)
		begin
			if(SW[0] == 1)
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd1	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd3	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd4	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd5	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd6	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd7	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[1] == 1)
			begin
					case(COL_counter%10 +10 )
						8'd10	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd11	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd12	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd13	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd14	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd15	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0001000}; end
						8'd16	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0001000}; end
						8'd17	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0001000}; end
						8'd18	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd19	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[2] == 1)
			begin
					case(COL_counter%10 + 20)
						8'd20	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd21	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd22	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd23	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd24	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd25	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0000111}; end
						8'd26	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0000111}; end
						8'd27	: begin dot_COL_reg <= 10'b0000000111; dot_raw_reg <= ~{7'b0000111}; end
						8'd28	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd29	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[3] == 1)
			begin
					case(COL_counter%10 + 30)
						8'd30	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd31	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd32	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd33	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd34	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd35	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd36	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd37	: begin dot_COL_reg <= 10'b1111111000; dot_raw_reg <= ~{7'b1110111}; end
						8'd38	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd39	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[4] == 1)
			begin
					case(COL_counter%10 +40)
						8'd40	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd41	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd42	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd43	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd44	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1110111}; end
						8'd45	: begin dot_COL_reg <= 10'b0001111111; dot_raw_reg <= ~{7'b0001000}; end
						8'd46	: begin dot_COL_reg <= 10'b0001111111; dot_raw_reg <= ~{7'b0001000}; end
						8'd47	: begin dot_COL_reg <= 10'b0001111111; dot_raw_reg <= ~{7'b0001000}; end
						8'd48	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd49	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[5] == 1)
			begin
					case(COL_counter%10 + 50)
						8'd50	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd51	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd52	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd53	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd54	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd55	: begin dot_COL_reg <= 10'b0001111000; dot_raw_reg <= ~{7'b0000111}; end
						8'd56	: begin dot_COL_reg <= 10'b0001111000; dot_raw_reg <= ~{7'b0000111}; end
						8'd57	: begin dot_COL_reg <= 10'b0001111000; dot_raw_reg <= ~{7'b0000111}; end
						8'd58	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd59	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[6] == 1)
			begin
					case(COL_counter%10 + 60)
						8'd60	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd61	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd62	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd63	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd64	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd65	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd66	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd67	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b1110111}; end
						8'd68	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd69	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if(SW[7] == 1)
			begin
					case(COL_counter%10 + 70)
						8'd70	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd71	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd72	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd73	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd74	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd75	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd76	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd77	: begin dot_COL_reg <= 10'b1111111111; dot_raw_reg <= ~{7'b1111111}; end
						8'd78	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd79	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end		
			else if(SW[8] == 1)
			begin
					case(COL_counter%10 + 80)
						8'd80	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd81	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd82	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd83	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd84	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd85	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd86	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd87	: begin dot_COL_reg <= 10'b1110000000; dot_raw_reg <= ~{7'b0000111}; end
						8'd88	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd89	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else
			begin
				case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd1	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd3	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd6	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd7	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
				endcase
			end
		end///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if(LEFT_K2==1)
		begin			
				if(Rec_start_sec==3'd1)
				begin
					case(COL_counter%10)
					4'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b1111111}; end
					4'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b1111111}; end
					4'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0000011}; end
					4'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0000011}; end
					4'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b1111111}; end
					4'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b1111111}; end
					4'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0000011}; end
					4'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0000011}; end
					4'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b1111111}; end
					4'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b1111111}; end
					endcase
				
				end
				
				else if(Rec_start_sec==3'd2)
				begin
					case(COL_counter%10)
					4'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b1111111}; end
					4'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b1111111}; end
					4'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0000011}; end
					4'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0000011}; end
					4'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b1111111}; end
					4'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b1111111}; end
					4'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b1100000}; end
					4'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b1100000}; end
					4'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b1111111}; end
					4'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b1111111}; end
					endcase
				end
				
				else if(Rec_start_sec==3'd3)
				begin
					case(COL_counter%10)
					4'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0001100}; end
					4'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0011100}; end
					4'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0011100}; end
					4'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0001100}; end
					4'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0001100}; end
					4'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0001100}; end
					4'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0001100}; end
					4'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0001100}; end
					4'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0001100}; end
					4'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0011110}; end
					endcase
				end
				
				else if(Rec_start_sec==3'd4)
				begin
					if(SW[8]==0)
					begin
							case(COL_counter%10)
							4'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b1111110}; end
							4'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b1111111}; end
							4'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b1100011}; end
							4'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b1100110}; end
							4'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b1101100}; end
							4'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b1111000}; end
							4'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b1110000}; end
							4'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b1101100}; end
							4'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b1100110}; end
							4'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b1100011}; end
							endcase
					end
					else
					begin
							case(COL_counter%10)
							4'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b1111110}; end
							4'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b1111111}; end
							4'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b1100011}; end
							4'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b1100011}; end
							4'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b1111110}; end
							4'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b1111100}; end
							4'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b1100000}; end
							4'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b1100000}; end
							4'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b1100000}; end
							4'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b1100000}; end
							endcase
					end
				end
				
			
				else
				begin
						case(COL_counter%10)
							8'd0	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end             
							8'd1	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd2	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd3	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd4	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd5	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd6	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd7	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
							8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						endcase
				
				end
					
					
					
				
		
		end////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
		else if(LEFT_K3==1)
		begin	
			if( (!(Mode_Switch)&&(KEY[0] == 1))		||		((Mode_Switch)&&(SW[0]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end             //C
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0011100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100010}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100000}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0011100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[1] == 1))		||		((Mode_Switch)&&(SW[1]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end             //D
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0111100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100010}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100010}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0111100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[2] == 1))		||		((Mode_Switch)&&(SW[2]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end              //E
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0111110}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0111110}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100000}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100000}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0111110}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[3] == 1))		||		((Mode_Switch)&&(SW[3]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end               //F
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0111100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0111100}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100000}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0100000}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[4] == 1))		||		((Mode_Switch)&&(SW[4]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end                //G
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0011100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0101110}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0011100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[5] == 1))		||		((Mode_Switch)&&(SW[5]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end            //A
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0011100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100010}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0111110}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[6] == 1))		||		((Mode_Switch)&&(SW[6]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end            //B
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0111100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0111110}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100010}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0111100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[7] == 1))		||		((Mode_Switch)&&(SW[7]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end             //C
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0011100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100010}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100000}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0011100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else if( (!(Mode_Switch)&&(KEY[8] == 1))		||		((Mode_Switch)&&(SW[8]==1)&&(cnt_K3_on)))
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000001; dot_raw_reg <= ~{7'b0000000}; end             //D
						8'd1	: begin dot_COL_reg <= 10'b0000000010; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000100; dot_raw_reg <= ~{7'b0111100}; end
						8'd3	: begin dot_COL_reg <= 10'b0000001000; dot_raw_reg <= ~{7'b0100010}; end
						8'd4	: begin dot_COL_reg <= 10'b0000010000; dot_raw_reg <= ~{7'b0100010}; end
						8'd5	: begin dot_COL_reg <= 10'b0000100000; dot_raw_reg <= ~{7'b0100010}; end
						8'd6	: begin dot_COL_reg <= 10'b0001000000; dot_raw_reg <= ~{7'b0100010}; end
						8'd7	: begin dot_COL_reg <= 10'b0010000000; dot_raw_reg <= ~{7'b0111100}; end
						8'd8	: begin dot_COL_reg <= 10'b0100000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b1000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
			else
			begin
					case(COL_counter%10)
						8'd0	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end             //X
						8'd1	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd2	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd3	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd4	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd5	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd6	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd7	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd8	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
						8'd9	: begin dot_COL_reg <= 10'b0000000000; dot_raw_reg <= ~{7'b0000000}; end
					endcase
			end
		end/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
	end
end	

assign DOT_COL = dot_COL_reg;

//assign DOT_RAW[13:7] = (COL_counter_1_delay > 4)? dot_raw_reg : ~{7'b0000000};
//assign DOT_RAW[6:0] = (COL_counter_1_delay < 5)? dot_raw_reg : ~{7'b0000000};

assign DOT_RAW[13:7] = dot_raw_reg ;
assign DOT_RAW[6:0] = dot_raw_reg ;

endmodule


