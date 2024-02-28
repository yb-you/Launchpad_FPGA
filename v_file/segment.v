`timescale 1ns / 1ps

//7-segment  ,  / pin 
module segment(
	input					CLK,
	input					RESET,
	input		[8:0]		KEY,
	input					Mode_Switch,
	output	reg	[3:0]		FND_COM,
	output	reg	[7:0]		FND_DATA
);

reg	[31:0]	cnt_time0;
reg				sec;
reg	[15:0]	cnt64k;
reg	[1:0]		cnt4;

reg	[15:0]	regseg;

wire	[7:0]		seg0;
wire	[7:0]		seg1;
wire	[7:0]		seg2;
wire	[7:0]		seg3;

reg [3:0] off_cnt;
reg [3:0] on_cnt;


reg [24:0] cnt1;
reg [1:0] cnt1_bit;
//////////////////////////////////////////////////////////////

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		cnt1 <= 25'd0;
	else if(cnt1<25'd11999999)                         //12000000 -> 0.5ÃÊ  (1¹Ú)
		cnt1 <= cnt1 + 25'd1;
	else
	cnt1 <= 25'd0;
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		cnt1_bit <= 0;
	else if(cnt1==25'd11999999)
	begin
			if(cnt1_bit == 2'd3)
				cnt1_bit <= 2'd0;
			else
				cnt1_bit<= cnt1_bit + 1'd1;
	end
end

////////////////////////////////////////////////////////////////////
always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		cnt_time0 <= 32'd0;
	else
		if (cnt_time0 < 32'd23999999)	
			cnt_time0 <= cnt_time0 + 32'd1;
		else
			cnt_time0 <= 32'd0;
end

always @ (posedge RESET or posedge CLK)
begin
	if (RESET)
		sec <= 16'd0;
	else
		if (cnt_time0 == 32'd23999999)
			sec <= 1'b1;
		else
			sec <= 1'b0;
end
 
always @ (posedge RESET or posedge CLK)
begin
	if (RESET)
		cnt64k <= 16'd0;
	else
		begin
			if (cnt64k < 16'hffff)
				cnt64k <= cnt64k + 16'd1;
			else
				cnt64k <= 16'd0;
		end
end
   
always @ (posedge RESET or posedge CLK)
begin
	if (RESET)
		cnt4 <= 2'b00;
	else
		begin
			if (cnt64k == 16'hffff)
				begin
					if (cnt4 < 2'b11)
						cnt4 <= cnt4 + 2'b01;
					else
						cnt4 <= 2'b00;
				end
		end
end


always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
	begin
		regseg <= 16'd0;
			
		off_cnt <= 4'd0;
		on_cnt <= 4'd0;
	end
	
	else 
	begin
		if(sec)
			if(regseg == 16'h9999)
				regseg <= 16'h0000;
			else if (regseg[11:0] == 12'h999)
				regseg <= {regseg[15:12] + 4'd1, 12'h000};
			else if (regseg[7:0] == 8'h99)
				regseg[11:0] <= {regseg[11:8] + 4'd1, 8'h00};
			else if (regseg[3:0] == 4'h9)
				regseg[7:0] <= {regseg[7:4] + 4'd1, 4'h0};
			else
				regseg[3:0] <= regseg[3:0] + 4'd1;
	end
end

		
always @ (cnt4)
begin
	case (cnt4)
		2'b00		:	FND_COM	<=	4'b1000;
		2'b01		:	FND_COM	<=	4'b0100;
		2'b10		:	FND_COM	<=	4'b0010;
		default	:	FND_COM	<=	4'b0001;
	endcase
end

//7-segment    
bin2seg u0 (.bin_data(regseg[15:12]), .seg_data(seg0));
bin2seg u1 (.bin_data(regseg[11:8]), .seg_data(seg1));
bin2seg u2 (.bin_data(regseg[7:4]), .seg_data(seg2));
bin2seg u3 (.bin_data(regseg[3:0]), .seg_data(seg3));

//7-segment 
always @ (FND_COM or seg0 or seg1 or seg2 or seg3)
begin
	if(cnt1_bit ==2'd0)
	begin
		case (FND_COM)
			4'b1000	:	FND_DATA	<=	8'b11101110; 
			4'b0100	:	FND_DATA	<=	8'b11110011; 
			4'b0010	:	FND_DATA	<=	8'b11110011;  
			default	:	FND_DATA	<=	8'b11110011; 
		endcase
	end
	if(cnt1_bit ==2'd1)
	begin
		case (FND_COM)
			4'b1000	:	FND_DATA	<=	8'b11110011; 
			4'b0100	:	FND_DATA	<=	8'b11101110; 
			4'b0010	:	FND_DATA	<=	8'b11110011;  
			default	:	FND_DATA	<=	8'b11110011; 
		endcase
	end
	if(cnt1_bit ==2'd2)
	begin
		case (FND_COM)
			4'b1000	:	FND_DATA	<=	8'b11110011; 
			4'b0100	:	FND_DATA	<=	8'b11110011; 
			4'b0010	:	FND_DATA	<=	8'b11101110;  
			default	:	FND_DATA	<=	8'b11110011; 
		endcase
	end
	if(cnt1_bit ==2'd3)
	begin
		case (FND_COM)
			4'b1000	:	FND_DATA	<=	8'b11110011; 
			4'b0100	:	FND_DATA	<=	8'b11110011; 
			4'b0010	:	FND_DATA	<=	8'b11110011;  
			default	:	FND_DATA	<=	8'b11101110; 
		endcase
	end
	/*
		4'b1000	:	FND_DATA	<=	8'b11101110; 
		4'b0100	:	FND_DATA	<=	seg1; 
		4'b0010	:	FND_DATA	<=	seg2; 
		default	:	FND_DATA	<=	seg3; 
	*/
end 

endmodule
