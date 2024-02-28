`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:24:32 08/20/2018 
// Design Name: 
// Module Name:    led_ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module led_ctrl(
	input RESET,
	input CLK,
	input Mode_Switch,
	input [8:0] KEY,
	output [7:0] LED,
	input		[3:0]	LEFT_KEY
);

reg status_led;
reg [24:0] cnt;
reg [7:0] regLED;

reg [7:0] regLED2;
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
	if(RESET)
		cnt <= 25'd0;
	else if(cnt<25'd11999999)
		cnt <= cnt + 25'd1;
	else
	cnt <= 25'd0;
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		status_led <= 0;
	else if(cnt==25'd11999999)
		status_led <= ~(status_led);
end


always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
	begin
		regLED <= 8'b11111111;
		regLED2 <= 8'b11111111;
		LEFT_K0 <= 0;
		LEFT_K1 <= 0;
		LEFT_K2 <= 0;
		LEFT_K3 <= 0;
		
		Rec_on <=0;
		Rec_cnt <=27'd0;
		Rec_wait <= 27'd0;
		Rec_start <=0;
	end
	else
	begin
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
	///////////////////////////////////////
		if(LEFT_K0==1) begin
				regLED 	<= 8'b11101110; 
				regLED2 	<= 8'b11101110; end
		else if(LEFT_K1==1) begin
				regLED 	<= 8'b11011101;
				regLED2	<= 8'b11011101;end	


				
		else if(LEFT_K2==1)///////////////////////////////////////////////////////
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
						if(status_led==1)begin
							regLED<=8'b10111011;
							regLED2<=8'b10111011; end
						else begin
							regLED<=8'b11111111;
							regLED2<=8'b11111111; end
					end
				end
			
				else
				begin
					regLED<=8'b10111011;	
					regLED2<=8'b10111011;
				end

		end
		else if(LEFT_K3==1)////////////////////////////////////////////////
				begin
					regLED<=8'b01110111;
					if(status_led==1)begin
						regLED2<=8'b01110111; end
					else begin
						regLED2<=8'b11111111; end
				end
		else begin
				regLED 	<= 8'b11111111;
				regLED	<= 8'b11111111;end	
				
		/////////////////////////////////	
		/*if(LEFT_KEY[2]==1) begin
			LEFT_K2<=~(LEFT_K2); end
		if(LEFT_K2==1)
		begin
			if(status_led==1) begin
				regLED <= 8'b10111011; end
			else begin
				regLED <= 8'b11111111; end
		end
		else begin
			regLED <= 8'b11111111; end
		///////////////////////////////////	
		if(LEFT_KEY[3]==1) begin
			LEFT_K3<=~(LEFT_K3); end
		if(LEFT_K3==1) 
		begin
			if(status_led==1) begin
				regLED <= 8'b01110111; end
			else begin
				regLED <= 8'b11111111; end
		end
		else begin
			regLED <= 8'b11111111; end*/
	end
end



assign LED = (!Mode_Switch) ? regLED : regLED2;      //(KEY[8]) ? 8'h0 : (8'hff ^ KEY[7:0]);


endmodule
