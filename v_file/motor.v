`timescale 1ns / 1ps
module motor(
	input		RESET,
	input 	Mode_Switch,
	input		CLK,
	input		[3:0]	LEFT_KEY,
	output	reg 	[3:0]	MOTOR_OUT,
	
	input[8:0] KEY
);

reg	[31:0]	cnt_motor;
reg	[7:0]		cnt_sw_dir;
reg	[7:0]		cnt_sw_on;
reg			sw_dir;
reg			sw_on;
wire	[31:0]	motor_speed;

reg			reg_MOTOR_DIR;
reg			reg_MOTOR_ON;
reg [8:0] SW;
reg	[31:0] Motor_time;
reg LEFT_K0;
reg LEFT_K1;
reg LEFT_K2;
reg LEFT_K3;

assign motor_speed = 32'd2000000; //Mode_Switch ? 32'd23900000 : 32'd2000000;

/*reg [24:0] cnt;

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		cnt <= 25'd0;
	else if(cnt<25'd24999999)
		cnt <= cnt + 25'd1;
	else
	cnt <= 25'd0;
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		Motor_time <= 0;
	else if(cnt==25'd24999999)
		Motor_time <= Motor_time+1'd1;
end*/

//    Edge Detector  Step Motor On/Off   
always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		begin
			reg_MOTOR_DIR	<=	1'b0;
			reg_MOTOR_ON		<=	1'b0;
			sw_dir			<=	1'b0;
			sw_on			<=	1'b0;
			SW<=9'b0;
			
			LEFT_K0 <= 0;
			LEFT_K1 <= 0;
			LEFT_K2 <= 0;
			LEFT_K3 <= 0;
		end
	else
		begin
			//reg_MOTOR_DIR	<=	LEFT_KEY[3];
			if(LEFT_KEY[0]==1) begin
				LEFT_K0<=1;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=0;
				sw_on<=1'b0; end
			else if(LEFT_KEY[1]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=1;
				LEFT_K2<=0;
				LEFT_K3<=0;
				sw_on<=1'b0; end	
			else if(LEFT_KEY[2]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=1;
				LEFT_K3<=0;
				sw_on<=1'b0; end	
			else if(LEFT_KEY[3]==1) begin
				LEFT_K0<=0;
				LEFT_K1<=0;
				LEFT_K2<=0;
				LEFT_K3<=1;
				sw_on<=1'b0; end
				
			if(KEY[0]==1)
				SW <= 9'b000000001;
			else if(KEY[1]==1)
				SW <= 9'b000000010;
			else if(KEY[2]==1)
				SW <= 9'b000000100;
			else if(KEY[3]==1)
				SW <= 9'b000001000;
			else if(KEY[4]==1)
				SW <= 9'b000010000;
			else if(KEY[5]==1)
				SW <= 9'b000100000;
			else if(KEY[6]==1)
				SW <= 9'b001000000;
			else if(KEY[7]==1)
				SW <= 9'b010000000;
			else if(KEY[8]==1)
				SW <= 9'b100000000;		
					
			if(LEFT_K0==1)/////////////////////////////////////////////////////////////////////////////////////////////////////////////
			begin
				if(KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					sw_on<=1'b1;
				if(sw_on==1)
				begin
					Motor_time<= Motor_time+1'd1;			
					if(SW == 9'b000000001)              //SW[0]
					begin
						if(Motor_time > 32'd95999999)    //96000000 ->4段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000010)         //SW[1]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000100)         //SW[2]
					begin
						if(Motor_time > 32'd95999999)    //96000000 ->4段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000001000)         //SW[3]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段   
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000010000)         //SW[4]
					begin
						if(Motor_time > 32'd191999999)   //192000000 ->8段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000100000)         //SW[5]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b001000000)        //SW[6]
					begin
						if(Motor_time > 32'd95999999)    //96000000 ->4段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b010000000)        //SW[7]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b100000000)          //SW[8]
					begin
						if(Motor_time > 32'd95999999)    //96000000 ->4段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end											
				end
			end//////////////////////////////////////////////////////////////////////////////////
			else if(LEFT_K1==1)
         begin
				if(KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					sw_on<=1'b1;
				if(sw_on==1)
				begin
					Motor_time<= Motor_time+1'd1;			
					if(SW == 9'b000000001)              //SW[0]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段 
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000010)         //SW[1]
					begin
						if(Motor_time > 32'd17999999)    //18000000 ->0.75段 
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000100)         //SW[2]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000001000)         //SW[3]
					begin
						if(Motor_time > 32'd17999999)    //18000000 ->0.75段  
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000010000)         //SW[4]
					begin
						if(Motor_time > 32'd17999999)    //18000000 ->0.75段 
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000100000)         //SW[5]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b001000000)        //SW[6]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b010000000)        //SW[7]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b100000000)          //SW[8]
					begin
						if(Motor_time > 32'd35999999)    //36000000 ->1.5段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end											
				end
			end///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			else if((LEFT_K3==1)&&(Mode_Switch))
			begin
				if(KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					sw_on<=1'b1;
				if(sw_on==1)
				begin
					Motor_time<= Motor_time+1'd1;			
					if(SW == 9'b000000001)              //SW[0]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000010)         //SW[1]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000000100)         //SW[2]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000001000)         //SW[3]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段   
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000010000)         //SW[4]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b000100000)         //SW[5]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b001000000)        //SW[6]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b010000000)        //SW[7]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end
					else if(SW == 9'b100000000)          //SW[8]
					begin
						if(Motor_time > 32'd47999999)    //48000000 ->2段
						begin
							sw_on<=1'b0;
							Motor_time <=32'd0;
							SW <= 9'b000000000;
						end
					end											
				end
			end
			
			
			/*if(LEFT_KEY[3] == 1'b1 & reg_MOTOR_DIR == 1'b0)
				sw_dir <= ~sw_dir;

			if(LEFT_KEY[2] == 1'b1 & reg_MOTOR_ON == 1'b0)
				sw_on <= ~sw_on;*/
		end
end
   
always @ (posedge RESET or posedge CLK)
begin
	if(RESET)
		begin
			cnt_motor <= 32'd0;
			MOTOR_OUT <= 4'b1001;
		end
	else
		begin
			if(!sw_on)
				cnt_motor <= 32'd0;
			else if(cnt_motor < (motor_speed-1))
				cnt_motor <= cnt_motor + 32'd1;
			else
				cnt_motor <= 32'd0;

			// motor_speed   MOTOR_OUT        .
			case (cnt_motor)
				0				:
					if(sw_dir)
						MOTOR_OUT <= 4'b0101;
					else
						MOTOR_OUT <= 4'b1001;

				(motor_speed/4)	:
					if(sw_dir)
						MOTOR_OUT <= 4'b0110;
					else
						MOTOR_OUT <= 4'b1010;

				(motor_speed/4)*2	:
					if(sw_dir)
						MOTOR_OUT <= 4'b1010;
					else
						MOTOR_OUT <= 4'b0110;

				(motor_speed/4)*3	:
					if(sw_dir)
						MOTOR_OUT <= 4'b1001;
					else
						MOTOR_OUT <= 4'b0101;
			endcase
		end
end

endmodule
