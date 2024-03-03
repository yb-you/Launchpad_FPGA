module piezo(
	input			RESET,
	input			CLK,
	input	[8:0]	KEY,
	output wire	BUZZER,
	input		[3:0]	LEFT_KEY,
	input Mode_Switch
);

parameter	[15:0]	reg_low_low_si	= 16'd24615;

parameter	[15:0]	reg_low_do	= 16'd23223;	   //1392
parameter	[15:0]	reg_low_do_s	= 16'd21952;    //low_do#	
parameter	[15:0]	reg_low_re	= 16'd20681;		//2542
parameter	[15:0]	reg_low_mi	= 16'd18411;		//2270
parameter	[15:0]	reg_low_pa	= 16'd17375;		//1036
parameter	[15:0]	reg_low_pa_s	= 16'd16421;    //low_pa#
parameter	[15:0]	reg_low_sol	= 16'd15467;		//1908
parameter	[15:0]	reg_low_sol_s	= 16'd14666;    //low_sol#
parameter	[15:0]	reg_low_ra	= 16'd13869;		//1598
parameter	[15:0]	reg_low_si	= 16'd12355;		//1514

parameter	[15:0]	reg_do		= 16'd11659;		//696
parameter	[15:0]	reg_do_s			= 16'd11023;    //do#
parameter	[15:0]	reg_re		= 16'd10388;		//1271
parameter	[15:0]	reg_re_s			= 16'd9820;    //re#
parameter	[15:0]	reg_mi		= 16'd9253;			//1135
parameter	[15:0]	reg_pa		= 16'd8736;			//518
parameter	[15:0]	reg_pa_s			= 16'd8259;    //pa#
parameter	[15:0]	reg_sol		= 16'd7782;			//954
parameter	[15:0]	reg_sol_s		= 16'd7328;    //sol#
parameter	[15:0]	reg_ra		= 16'd6929;			//799
parameter	[15:0]	reg_si		= 16'd6175;			//754

parameter	[15:0]	reg_high_do	= 16'd5827;			//348
parameter	[15:0]	reg_high_do_s	= 16'd5509;			//high_do#
parameter	[15:0]	reg_high_re	= 16'd5192;       //635
parameter	[15:0]	reg_high_mi	= 16'd4625;       //567
parameter	[15:0]	reg_high_pa	= 16'd4366;       //259
parameter	[15:0]	reg_high_pa_s	= 16'd4127;       //high_pa#
parameter	[15:0]	reg_high_sol	= 16'd3889;     //477
reg 						reg_break;
reg		[15:0]	buzzer_counter_max;
reg		[15:0]	buzzer_counter;
reg				regBUZZER;

reg 		[24:0]	cnt;
reg		[6:0]		status;
reg SW[8:0];
reg LEFT_K0;
reg LEFT_K1;
reg LEFT_K2;
reg LEFT_K3;


reg [26:0] Rec_cnt;
reg Rec_on;
reg Rec_play;
reg [15:0] Rec_mel;
reg [15:0] Rec0 ,	 Rec1, Rec2, 	 Rec3, 	 Rec4, 	 Rec5 , 	 Rec6,	 Rec7,	 Rec8, 	 Rec9,	
	  Rec10, Rec11,   Rec12,	 Rec13,	 Rec14, 	 Rec15,	Rec16, Rec17, Rec18, 	 Rec19, 
	  Rec20,  Rec21,   Rec22,	 Rec23,	 Rec24, 	 Rec25, 	 Rec26, 	 Rec27, 	 Rec28, Rec29, 
	  Rec30,  Rec31,  Rec32, 	 Rec33,   Rec34,	 Rec35,	 Rec36, 	 Rec37,  Rec38, 	Rec39,
	  Rec40,  Rec41,  Rec42, 	 Rec43, 	 Rec44, 	 Rec45, 	 Rec46, 	 Rec47, 	 Rec48, 	 Rec49,
	  Rec50,  Rec51,  Rec52,   Rec53,   Rec54,   Rec55,   Rec56,   Rec57,Rec58,   Rec59,
	  Rec60, Rec61 ,  Rec62,  Rec63;
	  
reg 		[24:0]	cnt_Rec;
reg		[6:0]		status_Rec;
reg		[26:0] Rec_wait;
reg		Rec_start;

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		cnt <= 25'd0;
	else if(cnt<25'd6000000)
		cnt <= cnt + 25'd1;
	else
	cnt <= 25'd0;
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		status <= 7'd0;
	else 
		if(cnt==25'd6000000)                        //0.25 (1/4)초
			if(status == 7'd64||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1 ||LEFT_KEY[2]==1)           //0.25초(1박) 64번(박) -> 16초 (2초 -> 1마디 -> 8박) 
				status <= 7'd0;
			else
				status <= status + 7'd1;
end


  
  
//////////////////////////////////////////////////////////////////////////////////
always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		cnt_Rec <= 25'd0;
	else
	begin
		if((Rec_on==1) && (LEFT_KEY[2]==0) &&	(Rec_start==1))
		begin
			if(cnt_Rec<25'd6000000)
				cnt_Rec <= cnt_Rec + 25'd1;
			else
				cnt_Rec <= 25'd0;
		end
		else
			cnt_Rec <= 25'd0;
	end
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		status_Rec <= 7'd0;
	else
	begin
		if((Rec_on==1) && (LEFT_KEY[2]==0) &&	(Rec_start==1))
		begin
			if(cnt_Rec==25'd6000000)                        //0.25 (1/4)초
				if(status_Rec == 7'd64 )                //0.25초(1박) 64번(박) -> 16초 (2초 -> 1마디 -> 8박) 
					status_Rec <= 7'd0;
				else
					status_Rec <= status_Rec + 7'd1;
		end
		else
			begin status_Rec<=7'd0; end
	end
end






























//////////////////////////////////////////////////////////////////////////////

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
	begin
		buzzer_counter_max <= 16'd0;
		reg_break <=0;
		SW[0]<=0;
		SW[1]<=0;
		SW[2]<=0;
		SW[3]<=0;
		SW[4]<=0;
		SW[5]<=0;
		SW[6]<=0;
		SW[7]<=0;
		SW[8]<=0;
		LEFT_K0 <= 0;
		LEFT_K1 <= 0;
		LEFT_K2 <= 0;
		LEFT_K3 <= 0;
		Rec_cnt <= 27'd0;
		Rec_on <=0;
		Rec_play <=0;
		Rec_mel <=16'd0;
	end
	else
	begin
		if(LEFT_KEY[0]==1) begin
			LEFT_K0<=1;
			LEFT_K1<=0;
			LEFT_K2<=0;
			LEFT_K3<=0;
			Rec_on <=0;
			Rec_play <=0;
			reg_break<=1;end
		else if(LEFT_KEY[1]==1) begin
			LEFT_K0<=0;
			LEFT_K1<=1;
			LEFT_K2<=0;
			LEFT_K3<=0;
			Rec_on <=0;
			Rec_play <=0;
			reg_break<=1;end	
		else if(LEFT_KEY[2]==1) begin
			LEFT_K0<=0;
			LEFT_K1<=0;
			LEFT_K2<=1;
			LEFT_K3<=0;
			reg_break<=1;			
			end	
		else if(LEFT_KEY[3]==1) begin
			LEFT_K0<=0;
			LEFT_K1<=0;
			LEFT_K2<=0;
			LEFT_K3<=1;
			Rec_on <=0;
			Rec_play <=0;
			reg_break<=1;end	
			
		if(LEFT_K0==1)/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		begin
			if(KEY[0]==1)begin
				SW[0]<=1;
				reg_break<=0;end
			if(SW[0]==1)
			begin
				case(status)                                            //16박 ->4초
					7'd0	:	buzzer_counter_max <= reg_mi; 
					7'd1	:	buzzer_counter_max <= reg_mi;
					7'd2	:	buzzer_counter_max <= reg_mi;
					7'd3	:	buzzer_counter_max <= reg_re;
					7'd4	:	buzzer_counter_max <= reg_do;
					7'd5	:	buzzer_counter_max <= reg_do;
					7'd6	:	buzzer_counter_max <= reg_re;
					7'd7	:	buzzer_counter_max <= reg_re;
					7'd8	:	buzzer_counter_max <= reg_mi;
					7'd9	:	reg_break<=1;
					7'd10	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd11	:	reg_break<=1;
					7'd12	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd13	:	buzzer_counter_max <= reg_mi;
					7'd14	:	buzzer_counter_max <= reg_mi;
					7'd15	:	buzzer_counter_max <= reg_mi;
				endcase
				if(status>7'd15||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[0]<=0;	
			end

			if(KEY[1]==1)begin
				SW[1]<=1;
				reg_break<=0;end
			if(SW[1]==1)
			begin
				case(status)
					7'd0	:	buzzer_counter_max <= reg_high_re; 
					7'd1	:	buzzer_counter_max <= reg_high_re; 
					7'd2	:	buzzer_counter_max <= reg_high_re; 
					7'd3	:	buzzer_counter_max <= reg_high_re; 
					7'd4	:	buzzer_counter_max <= reg_high_re; 
					7'd5	:	buzzer_counter_max <= reg_high_re; 
					7'd6	:	buzzer_counter_max <= reg_high_mi; 
					7'd7	:	buzzer_counter_max <= reg_high_re; 
				endcase
				if(status>7'd7||KEY[0]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[1]<=0;	
			end

			if(KEY[2]==1)begin
				SW[2]<=1;
				reg_break<=0;end
			if(SW[2]==1)
			begin
				case(status)                                             //16박 ->4초
					7'd0	:	buzzer_counter_max <= reg_re; 
					7'd1	:	reg_break<=1;
					7'd2	:	begin reg_break<=0; buzzer_counter_max <= reg_re; end
					7'd3	:	reg_break<=1;
					7'd4	:	begin reg_break<=0; buzzer_counter_max <= reg_re; end
					7'd5	:	buzzer_counter_max <= reg_re;
					7'd6	:	buzzer_counter_max <= reg_re;
					7'd7	:	buzzer_counter_max <= reg_re;
					7'd8	:	buzzer_counter_max <= reg_mi;
					7'd9	:	buzzer_counter_max <= reg_mi;
					7'd10	:	buzzer_counter_max <= reg_sol;
					7'd11	:	reg_break<=1;
					7'd12	:	begin reg_break<=0; buzzer_counter_max <= reg_sol; end
					7'd13	:	buzzer_counter_max <= reg_sol;
					7'd14	:	buzzer_counter_max <= reg_sol;
					7'd15	:	buzzer_counter_max <= reg_sol;
				endcase
				if(status>7'd15||KEY[0]==1||KEY[1]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[2]<=0;	
			end

			if(KEY[3]==1)begin
				SW[3]<=1;
				reg_break<=0;end
			if(SW[3]==1)
			begin
				case(status)
					7'd0	:	buzzer_counter_max <= reg_high_do; 
					7'd1	:	buzzer_counter_max <= reg_high_do; 
					7'd2	:	buzzer_counter_max <= reg_high_do; 
					7'd3	:	buzzer_counter_max <= reg_high_do; 
					7'd4	:	buzzer_counter_max <= reg_high_do;
					7'd5	:	buzzer_counter_max <= reg_sol;
					7'd6	:	buzzer_counter_max <= reg_high_do;
					7'd7	:	buzzer_counter_max <= reg_high_re;
				endcase
				if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[3]<=0;	
			end

			if(KEY[4]==1)begin
				SW[4]<=1;
				reg_break<=0;end
			if(SW[4]==1)
			begin
				case(status)
					7'd0	:	buzzer_counter_max <= reg_do; 
					7'd1	:	buzzer_counter_max <= reg_do; 
					7'd2	:	buzzer_counter_max <= reg_do; 
					7'd3	:	buzzer_counter_max <= reg_do; 
					7'd4	:	buzzer_counter_max <= reg_do; 
					7'd5	:	buzzer_counter_max <= reg_high_do; 
					7'd6	:	buzzer_counter_max <= reg_si;
					7'd7	:	buzzer_counter_max <= reg_ra;
					
					7'd8	:	buzzer_counter_max <= reg_ra;
					7'd9	:	buzzer_counter_max <= reg_ra;
					7'd10	:	buzzer_counter_max <= reg_ra;
					7'd11	:	reg_break<=1; 
					7'd12	:	begin reg_break<=0; buzzer_counter_max <= reg_ra; end
					7'd13	:	buzzer_counter_max <= reg_ra;
					7'd14	:	buzzer_counter_max <= reg_sol;
					7'd15	:	buzzer_counter_max <= reg_mi;
					
					7'd16	:	buzzer_counter_max <= reg_mi;
					7'd17	:	buzzer_counter_max <= reg_mi;
					7'd18	:	buzzer_counter_max <= reg_mi;
					7'd19	:	buzzer_counter_max <= reg_mi;
					7'd20	:	reg_break<=1;
					7'd21	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd22	:	buzzer_counter_max <= reg_mi;
					7'd23	:	buzzer_counter_max <= reg_re;
					
					7'd24	:	buzzer_counter_max <= reg_re;
					7'd25	:	buzzer_counter_max <= reg_re;
					7'd26	:	buzzer_counter_max <= reg_re;
					7'd27	:	buzzer_counter_max <= reg_re;
					7'd28	:	buzzer_counter_max <= reg_mi;
					7'd29	:	buzzer_counter_max <= reg_mi;
					7'd30	:	buzzer_counter_max <= reg_sol;
					7'd31	:	buzzer_counter_max <= reg_sol;
					
				endcase
				if(status>7'd31||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[4]<=0;	
			end
			
			if(KEY[5]==1)begin
				SW[5]<=1;
				reg_break<=0;end
			if(SW[5]==1)
			begin
				case(status)
					7'd0	:	buzzer_counter_max <= reg_high_mi; 
					7'd1	:	buzzer_counter_max <= reg_high_mi;
					7'd2	:	buzzer_counter_max <= reg_high_mi;
					7'd3	:	buzzer_counter_max <= reg_high_mi;
					7'd4	:	buzzer_counter_max <= reg_high_mi;
					7'd5	:	reg_break<=1;
					7'd6	:	begin reg_break<=0; buzzer_counter_max <= reg_high_mi; end
					7'd7	:	buzzer_counter_max <= reg_high_mi;
				endcase
				if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[5]<=0;	
			end

			if(KEY[6]==1)begin
				SW[6]<=1;
				reg_break<=0;end
			if(SW[6]==1)
			begin
				case(status)                                           //16박 ->4초
					7'd0	:	buzzer_counter_max <= reg_mi; 
					7'd1	:	buzzer_counter_max <= reg_mi;
					7'd2	:	buzzer_counter_max <= reg_mi;
					7'd3	:	buzzer_counter_max <= reg_re;
					7'd4	:	buzzer_counter_max <= reg_do;
					7'd5	:	buzzer_counter_max <= reg_do;
					7'd6	:	buzzer_counter_max <= reg_re;
					7'd7	:	buzzer_counter_max <= reg_re;
					7'd8	:	buzzer_counter_max <= reg_mi;
					7'd9	:	reg_break<=1;
					7'd10	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd11	:	reg_break<=1;
					7'd12	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd13	:	buzzer_counter_max <= reg_mi;
					7'd14	:	buzzer_counter_max <= reg_mi;
					7'd15	:	buzzer_counter_max <= reg_mi;
				endcase
				if(status>7'd15||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[7]==1||KEY[8]==1)
					SW[6]<=0;	
			end
			
			if(KEY[7]==1)begin
				SW[7]<=1;
				reg_break<=0;end
			if(SW[7]==1)
			begin
				case(status)
					7'd0	:	buzzer_counter_max <= reg_high_do;
					7'd1	:	buzzer_counter_max <= reg_high_do;
					7'd2	:	buzzer_counter_max <= reg_high_do;
					7'd3	:	buzzer_counter_max <= reg_high_do;
					7'd4	:	buzzer_counter_max <= reg_high_do;
					7'd5	:	buzzer_counter_max <= reg_high_do;
					7'd6	:	buzzer_counter_max <= reg_high_do;
					7'd7	:	buzzer_counter_max <= reg_high_do;
				endcase
				if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[8]==1)
					SW[7]<=0;	
			end
			
			if(KEY[8]==1)begin
				SW[8]<=1;
				reg_break<=0;end
			if(SW[8]==1)
			begin
				case(status)                                                //16박 ->4초
					7'd0	:	buzzer_counter_max <= reg_re; 
					7'd1	:	reg_break<=1;
					7'd2	:	begin reg_break<=0; buzzer_counter_max <= reg_re; end
					7'd3	:	reg_break<=1;
					7'd4	:	begin reg_break<=0; buzzer_counter_max <= reg_mi; end
					7'd5	:	buzzer_counter_max <= reg_mi;
					7'd6	:	buzzer_counter_max <= reg_re;
					7'd7	:	buzzer_counter_max <= reg_re;
					7'd8	:	buzzer_counter_max <= reg_do;
					7'd9	:	buzzer_counter_max <= reg_do;
					7'd10	:	buzzer_counter_max <= reg_do;
					7'd11	:	buzzer_counter_max <= reg_do;
					7'd12	:	buzzer_counter_max <= reg_do;
					7'd13	:	buzzer_counter_max <= reg_do;
					7'd14	:	buzzer_counter_max <= reg_do;
					7'd15	:	buzzer_counter_max <= reg_do;
				endcase
				if(status>7'd15||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1)
					SW[8]<=0;	
			end
		end		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		else if(LEFT_K1==1)
		begin
			if(KEY[0]==1)begin
				SW[0]<=1;
				reg_break<=0;end
			if(SW[0]==1)
			begin
				case(status)                                            //6박 ->1.5초
					7'd0	:	buzzer_counter_max <= reg_re; 
					7'd1	:	buzzer_counter_max <= reg_do_s; 
					7'd2	:	buzzer_counter_max <= reg_low_ra; 
					7'd3	:	buzzer_counter_max <= reg_low_pa_s; 
					7'd4	:	buzzer_counter_max <= reg_low_mi; 
					7'd5	:	buzzer_counter_max <= reg_low_re; 		
				endcase
				if(status>7'd5||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[0]<=0;	
			end
			
			if(KEY[1]==1)begin
				SW[1]<=1;
				reg_break<=0;end
			if(SW[1]==1)
			begin
				case(status)                                            //3박 ->0.75초
					7'd0	:	buzzer_counter_max <= reg_low_low_si; 
					7'd1	:	buzzer_counter_max <= reg_low_do_s; 
					7'd2	:	buzzer_counter_max <= reg_low_re; 		
				endcase
				if(status>7'd2||KEY[0]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[1]<=0;	
			end

			if(KEY[2]==1)begin
				SW[2]<=1;
				reg_break<=0;end
			if(SW[2]==1)
			begin
				case(status)                                            //6박 ->1.5초
					7'd0	:	buzzer_counter_max <= reg_low_pa_s; 
					7'd1	:	reg_break<=1;
					7'd2	:	begin reg_break<=0;	buzzer_counter_max <= reg_low_ra; end
					7'd3	:	buzzer_counter_max <= reg_low_mi; 
					7'd4	:	reg_break<=1;
					7'd5	:	begin reg_break<=0;	buzzer_counter_max <= reg_low_ra; end
				endcase
				if(status>7'd5||KEY[0]==1||KEY[1]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[2]<=0;	
			end	

			if(KEY[3]==1)begin
				SW[3]<=1;
				reg_break<=0;end
			if(SW[3]==1)
			begin
				case(status)                                            //3박 ->0.75초
					7'd0	:	buzzer_counter_max <= reg_low_pa_s; 
					7'd1	:	buzzer_counter_max <= reg_low_pa_s; 
					7'd2	:	buzzer_counter_max <= reg_low_pa_s;
				endcase
				if(status>7'd2||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[3]<=0;	
			end

			if(KEY[4]==1)begin
				SW[4]<=1;
				reg_break<=0;end
			if(SW[4]==1)
			begin
				case(status)                                            //3박 ->0.75초
					7'd0	:	buzzer_counter_max <= reg_low_do_s; 
					7'd1	:	buzzer_counter_max <= reg_low_re; 
					7'd2	:	buzzer_counter_max <= reg_low_mi; 		
				endcase
				if(status>7'd2||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[4]<=0;	
			end

			if(KEY[5]==1)begin
				SW[5]<=1;
				reg_break<=0;end
			if(SW[5]==1)
			begin
				case(status)                                            //6박 ->1.5초
					7'd0	:	buzzer_counter_max <= reg_low_si; 
					7'd1	:	buzzer_counter_max <= reg_do_s; 
					7'd2	:	buzzer_counter_max <= reg_re; 
					7'd3	:	buzzer_counter_max <= reg_do_s; 
					7'd4	:	buzzer_counter_max <= reg_low_si; 
					7'd5	:	buzzer_counter_max <= reg_low_ra;
				endcase
				if(status>7'd5||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
					SW[5]<=0;	
			end

			if(KEY[6]==1)begin
				SW[6]<=1;
				reg_break<=0;end
			if(SW[6]==1)
			begin
				case(status)                                            //6박 ->1.5초
					7'd0	:	buzzer_counter_max <= reg_re; 
					7'd1	:	reg_break<=1;
					7'd2	:	begin reg_break<=0;	buzzer_counter_max <= reg_ra; end
					7'd3	:	buzzer_counter_max <= reg_do_s; 
					7'd4	:	reg_break<=1;
					7'd5	:	begin reg_break<=0;	buzzer_counter_max <= reg_ra; end
				endcase
				if(status>7'd5||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[7]==1||KEY[8]==1)
					SW[6]<=0;	
			end	

			if(KEY[7]==1)begin
				SW[7]<=1;
				reg_break<=0;end
			if(SW[7]==1)
			begin
				case(status)                                            //3박 ->0.75초
					7'd0	:	buzzer_counter_max <= reg_low_re; 
					7'd1	:	buzzer_counter_max <= reg_low_re; 
					7'd2	:	buzzer_counter_max <= reg_low_re; 		
					7'd3	:	buzzer_counter_max <= reg_low_re; 
					7'd4	:	buzzer_counter_max <= reg_low_re; 
					7'd5	:	buzzer_counter_max <= reg_low_re; 
				endcase
				if(status>7'd5||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[8]==1)
					SW[7]<=0;	
			end
			
			if(KEY[8]==1)begin
				SW[8]<=1;
				reg_break<=0;end
			if(SW[8]==1)
			begin
				case(status)                                            //6박 ->1.5초
					7'd0	:	buzzer_counter_max <= reg_pa_s; 
					7'd1	:	reg_break<=1;
					7'd2	:	begin reg_break<=0;	buzzer_counter_max <= reg_ra; end
					7'd3	:	buzzer_counter_max <= reg_mi; 
					7'd4	:	reg_break<=1;
					7'd5	:	begin reg_break<=0;	buzzer_counter_max <= reg_ra; end
				endcase
				if(status>7'd5||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1)
					SW[8]<=0;	
			end	
				
		end//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		else if(LEFT_K2==1)
		begin

			if(LEFT_KEY[2]==1)
			begin
				if(Rec_on ==0)
				begin
						if(Rec_cnt >27'd71999999)
						begin
								Rec_on <=1;
								Rec_cnt<= 27'd0;
								Rec_play <=0;
						end
						else	begin	Rec_cnt<= Rec_cnt+ 27'd1;	end
				end
			Rec0<=16'd0;  Rec1<=16'd0;  Rec2<=16'd0;  Rec3<=16'd0;  Rec4<=16'd0;  Rec5<=16'd0;  Rec6<=16'd0;  Rec7<=16'd0;  Rec8<=16'd0;  Rec9<=16'd0;
			Rec10<=16'd0; Rec11<=16'd0; Rec12<=16'd0; Rec13<=16'd0; Rec14<=16'd0; Rec15<=16'd0; Rec16<=16'd0; Rec17<=16'd0; Rec18<=16'd0; Rec19<=16'd0;
			Rec20<=16'd0; Rec21<=16'd0; Rec22<=16'd0; Rec23<=16'd0; Rec24<=16'd0; Rec25<=16'd0; Rec26<=16'd0; Rec27<=16'd0; Rec28<=16'd0; Rec29<=16'd0;
			Rec30<=16'd0; Rec31<=16'd0; Rec32<=16'd0; Rec33<=16'd0; Rec34<=16'd0; Rec35<=16'd0; Rec36<=16'd0; Rec37<=16'd0; Rec38<=16'd0; Rec39<=16'd0;
			Rec40<=16'd0; Rec41<=16'd0; Rec42<=16'd0; Rec43<=16'd0; Rec44<=16'd0; Rec45<=16'd0; Rec46<=16'd0; Rec47<=16'd0; Rec48<=16'd0; Rec49<=16'd0;
			Rec50<=16'd0; Rec51<=16'd0; Rec52<=16'd0; Rec53<=16'd0; Rec54<=16'd0; Rec55<=16'd0; Rec56<=16'd0; Rec57<=16'd0; Rec58<=16'd0; Rec59<=16'd0;
			Rec60<=16'd0; Rec61<=16'd0; Rec62<=16'd0; Rec63<=16'd0;
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
						reg_break<=0;
						if(KEY[0]) begin Rec_mel <= reg_do; buzzer_counter_max <= reg_do; end
						else if(KEY[1]) begin Rec_mel <= reg_re; buzzer_counter_max <= reg_re; end
						else if(KEY[2]) begin Rec_mel <= reg_mi; buzzer_counter_max <= reg_mi; end
						else if(KEY[3]) begin Rec_mel <= reg_pa; buzzer_counter_max <= reg_pa; end
						else if(KEY[4]) begin Rec_mel <= reg_sol; buzzer_counter_max <= reg_sol; end
						else if(KEY[5]) begin Rec_mel <= reg_ra; buzzer_counter_max <= reg_ra; end
						else if(KEY[6]) begin Rec_mel <= reg_si; buzzer_counter_max <= reg_si; end
						else if(KEY[7]) begin Rec_mel <= reg_high_do; buzzer_counter_max <= reg_high_do; end
						else begin Rec_mel <= 16'd0 ; end
						//else if(KEY[8]) begin Rec_mel <= reg_high_re; buzzer_counter_max <= reg_high_re; end	
				
			
						case(status_Rec)
							7'd0	:	Rec0 <= Rec_mel;
							7'd1	:	Rec1 <= Rec_mel;
							7'd2	:	Rec2 <= Rec_mel;
							7'd3	:	Rec3 <= Rec_mel;
							7'd4	:	Rec4 <= Rec_mel;
							7'd5	:	Rec5 <= Rec_mel;
							7'd6	:	Rec6 <= Rec_mel;
							7'd7	:	Rec7 <= Rec_mel;
							7'd8	:	Rec8 <= Rec_mel;
							7'd9	:	Rec9 <= Rec_mel;
							
							7'd10	:	Rec10 <= Rec_mel;
							7'd11	:	Rec11 <= Rec_mel;
							7'd12	:	Rec12 <= Rec_mel;
							7'd13	:	Rec13 <= Rec_mel;
							7'd14	:	Rec14 <= Rec_mel;
							7'd15	:	Rec15 <= Rec_mel;
							7'd16	:	Rec16 <= Rec_mel;
							7'd17	:	Rec17 <= Rec_mel;
							7'd18	:	Rec18 <= Rec_mel;
							7'd19	:	Rec19 <= Rec_mel;
							
							7'd20	:	Rec20 <= Rec_mel;
							7'd21	:	Rec21 <= Rec_mel;
							7'd22	:	Rec22 <= Rec_mel;
							7'd23	:	Rec23 <= Rec_mel;
							7'd24	:	Rec24 <= Rec_mel;
							7'd25	:	Rec25 <= Rec_mel;
							7'd26	:	Rec26 <= Rec_mel;
							7'd27	:	Rec27 <= Rec_mel;
							7'd28	:	Rec28 <= Rec_mel;
							7'd29	:	Rec29 <= Rec_mel;
							
							7'd30	:	Rec30 <= Rec_mel;
							7'd31	:	Rec31 <= Rec_mel;
							7'd32	:	Rec32 <= Rec_mel;
							7'd33	:	Rec33 <= Rec_mel;
							7'd34	:	Rec34 <= Rec_mel;
							7'd35	:	Rec35 <= Rec_mel;
							7'd36	:	Rec36 <= Rec_mel;
							7'd37	:	Rec37 <= Rec_mel;
							7'd38	:	Rec38 <= Rec_mel;
							7'd39	:	Rec39 <= Rec_mel;
							
							7'd40	:	Rec40 <= Rec_mel;
							7'd41	:	Rec41 <= Rec_mel;
							7'd42	:	Rec42 <= Rec_mel;
							7'd43	:	Rec43 <= Rec_mel;
							7'd44	:	Rec44 <= Rec_mel;
							7'd45	:	Rec45 <= Rec_mel;
							7'd46	:	Rec46 <= Rec_mel;
							7'd47	:	Rec47 <= Rec_mel;
							7'd48	:	Rec48 <= Rec_mel;
							7'd49	:	Rec49 <= Rec_mel;
							
							7'd50	:	Rec50 <= Rec_mel;
							7'd51	:	Rec51 <= Rec_mel;
							7'd52	:	Rec52 <= Rec_mel;
							7'd53	:	Rec53 <= Rec_mel;
							7'd54	:	Rec54 <= Rec_mel;
							7'd55	:	Rec55 <= Rec_mel;
							7'd56	:	Rec56 <= Rec_mel;
							7'd57	:	Rec57 <= Rec_mel;
							7'd58	:	Rec58 <= Rec_mel;
							7'd59	:	Rec59 <= Rec_mel;
							
							7'd60	:	Rec60 <= Rec_mel;
							7'd61	:	Rec61 <= Rec_mel;
							7'd62	:	Rec62 <= Rec_mel;
							7'd63	:	Rec63 <= Rec_mel;	
						endcase
				
						if(KEY[8]==1 || status_Rec == 7'd64)
						begin
							Rec_play <=1;
							Rec_on <=0;
							Rec_start<= 0 ;
						end
						
						
				end
				
				
			end
			/////////////////////////////////////////////////////////////////////
			if(Rec_play ==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	begin if(Rec0==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec0; end end
						7'd1	:	begin if(Rec1==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec1; end end
						7'd2	:	begin if(Rec2==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec2; end end
						7'd3	:	begin if(Rec3==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec3; end end
						7'd4	:	begin if(Rec4==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec4; end end
						7'd5	:	begin if(Rec5==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec5; end end
						7'd6	:	begin if(Rec6==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec6; end end 
						7'd7	:	begin if(Rec7==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec7; end end
						7'd8	:	begin if(Rec8==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec8; end end
						7'd9	:	begin if(Rec9==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec9; end end
						
						7'd10	:	begin if(Rec10==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec10; end end
						7'd11	:	begin if(Rec11==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec11; end end
						7'd12	:	begin if(Rec12==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec12; end end
						7'd13	:	begin if(Rec13==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec13; end end
						7'd14	:	begin if(Rec14==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec14; end end
						7'd15	:	begin if(Rec15==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec15; end end
						7'd16	:	begin if(Rec16==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec16; end end 
						7'd17	:	begin if(Rec17==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec17; end end
						7'd18	:	begin if(Rec18==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec18; end end
						7'd19	:	begin if(Rec19==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec19; end end
						
						7'd20	:	begin if(Rec20==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec20; end end
						7'd21	:	begin if(Rec21==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec21; end end
						7'd22	:	begin if(Rec22==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec22; end end
						7'd23	:	begin if(Rec23==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec23; end end
						7'd24	:	begin if(Rec24==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec24; end end
						7'd25	:	begin if(Rec25==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec25; end end
						7'd26	:	begin if(Rec26==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec26; end end 
						7'd27	:	begin if(Rec27==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec27; end end
						7'd28	:	begin if(Rec28==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec28; end end
						7'd29	:	begin if(Rec29==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec29; end end
						
						7'd30	:	begin if(Rec30==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec30; end end
						7'd31	:	begin if(Rec31==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec31; end end
						7'd32	:	begin if(Rec32==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec32; end end
						7'd33	:	begin if(Rec33==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec33; end end
						7'd34	:	begin if(Rec34==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec34; end end
						7'd35	:	begin if(Rec35==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec35; end end
						7'd36	:	begin if(Rec36==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec36; end end 
						7'd37	:	begin if(Rec37==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec37; end end
						7'd38	:	begin if(Rec38==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec38; end end
						7'd39	:	begin if(Rec39==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec39; end end
						
						7'd40	:	begin if(Rec40==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec40; end end
						7'd41	:	begin if(Rec41==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec41; end end
						7'd42	:	begin if(Rec42==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec42; end end
						7'd43	:	begin if(Rec43==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec43; end end
						7'd44	:	begin if(Rec44==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec44; end end
						7'd45	:	begin if(Rec45==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec45; end end
						7'd46	:	begin if(Rec46==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec46; end end 
						7'd47	:	begin if(Rec47==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec47; end end
						7'd48	:	begin if(Rec48==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec48; end end
						7'd49	:	begin if(Rec49==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec49; end end
						
						7'd50	:	begin if(Rec50==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec50; end end
						7'd51	:	begin if(Rec51==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec51; end end
						7'd52	:	begin if(Rec52==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec52; end end
						7'd53	:	begin if(Rec53==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec53; end end
						7'd54	:	begin if(Rec54==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec54; end end
						7'd55	:	begin if(Rec55==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec55; end end
						7'd56	:	begin if(Rec56==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec56; end end 
						7'd57	:	begin if(Rec57==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec57; end end
						7'd58	:	begin if(Rec58==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec58; end end
						7'd59	:	begin if(Rec59==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec59; end end
						
						7'd60	:	begin if(Rec60==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec60; end end
						7'd61	:	begin if(Rec61==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec61; end end
						7'd62	:	begin if(Rec62==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec62; end end
						7'd63	:	begin if(Rec63==16'd0)begin reg_break<=1; end  else begin reg_break<= 0; buzzer_counter_max <= Rec63; end end
					endcase
				end
			
			
			
		end////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		else if(LEFT_K3==1)
		begin
			if(!Mode_Switch)
			begin
				if(KEY[0])	buzzer_counter_max <= reg_do;
				else if(KEY[1])	buzzer_counter_max <= reg_re;
				else if(KEY[2])	buzzer_counter_max <= reg_mi;
				else if(KEY[3])	buzzer_counter_max <= reg_pa;
				else if(KEY[4])	buzzer_counter_max <= reg_sol;
				else if(KEY[5])	buzzer_counter_max <= reg_ra;
				else if(KEY[6])	buzzer_counter_max <= reg_si;
				else if(KEY[7])	buzzer_counter_max <= reg_high_do;
				else if(KEY[8])	buzzer_counter_max <= reg_high_re;
			end
			
			else
			begin
				if(KEY[0]==1)begin
					SW[0]<=1;
					reg_break<=0;end
				if(SW[0]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_do; 
						7'd1	:	buzzer_counter_max <= reg_low_mi;
						7'd2	:	buzzer_counter_max <= reg_low_sol;
						7'd3	:	buzzer_counter_max <= reg_do;
						7'd4	:	buzzer_counter_max <= reg_mi;
						7'd5	:	buzzer_counter_max <= reg_low_do;
						7'd6	:	buzzer_counter_max <= reg_low_sol;
						7'd7	:	buzzer_counter_max <= reg_low_mi;
					endcase
					if(status>7'd7||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[0]<=0;	
				end
				
				if(KEY[1]==1)begin
					SW[1]<=1;
					reg_break<=0;end
				if(SW[1]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_re; 
						7'd1	:	buzzer_counter_max <= reg_low_pa_s;
						7'd2	:	buzzer_counter_max <= reg_low_ra;
						7'd3	:	buzzer_counter_max <= reg_re;
						7'd4	:	buzzer_counter_max <= reg_pa_s;
						7'd5	:	buzzer_counter_max <= reg_re;
						7'd6	:	buzzer_counter_max <= reg_low_ra;
						7'd7	:	buzzer_counter_max <= reg_low_pa_s;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[1]<=0;	
				end

				if(KEY[2]==1)begin
					SW[2]<=1;
					reg_break<=0;end
				if(SW[2]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_mi; 
						7'd1	:	buzzer_counter_max <= reg_low_sol_s;
						7'd2	:	buzzer_counter_max <= reg_low_si;
						7'd3	:	buzzer_counter_max <= reg_mi;
						7'd4	:	buzzer_counter_max <= reg_sol_s;
						7'd5	:	buzzer_counter_max <= reg_mi;
						7'd6	:	buzzer_counter_max <= reg_low_si;
						7'd7	:	buzzer_counter_max <= reg_low_sol_s;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[2]<=0;	
				end

				if(KEY[3]==1)begin
					SW[3]<=1;
					reg_break<=0;end
				if(SW[3]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_pa; 
						7'd1	:	buzzer_counter_max <= reg_low_ra;
						7'd2	:	buzzer_counter_max <= reg_do;
						7'd3	:	buzzer_counter_max <= reg_pa;
						7'd4	:	buzzer_counter_max <= reg_ra;
						7'd5	:	buzzer_counter_max <= reg_pa;
						7'd6	:	buzzer_counter_max <= reg_do;
						7'd7	:	buzzer_counter_max <= reg_low_ra;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[3]<=0;	
				end


				if(KEY[4]==1)begin
					SW[4]<=1;
					reg_break<=0;end
				if(SW[4]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_sol; 
						7'd1	:	buzzer_counter_max <= reg_low_si;
						7'd2	:	buzzer_counter_max <= reg_re;
						7'd3	:	buzzer_counter_max <= reg_sol;
						7'd4	:	buzzer_counter_max <= reg_si;
						7'd5	:	buzzer_counter_max <= reg_sol;
						7'd6	:	buzzer_counter_max <= reg_re;
						7'd7	:	buzzer_counter_max <= reg_low_si;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[4]<=0;	
				end

				if(KEY[5]==1)begin
					SW[5]<=1;
					reg_break<=0;end
				if(SW[5]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_ra; 
						7'd1	:	buzzer_counter_max <= reg_do_s;
						7'd2	:	buzzer_counter_max <= reg_mi;
						7'd3	:	buzzer_counter_max <= reg_ra;
						7'd4	:	buzzer_counter_max <= reg_high_do_s;
						7'd5	:	buzzer_counter_max <= reg_ra;
						7'd6	:	buzzer_counter_max <= reg_mi;
						7'd7	:	buzzer_counter_max <= reg_do_s;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[6]==1||KEY[7]==1||KEY[8]==1)
						SW[5]<=0;	
				end
				
				if(KEY[6]==1)begin
					SW[6]<=1;
					reg_break<=0;end
				if(SW[6]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_low_si; 
						7'd1	:	buzzer_counter_max <= reg_re_s;
						7'd2	:	buzzer_counter_max <= reg_pa_s;
						7'd3	:	buzzer_counter_max <= reg_si;
						7'd4	:	buzzer_counter_max <= reg_high_re;
						7'd5	:	buzzer_counter_max <= reg_si;
						7'd6	:	buzzer_counter_max <= reg_pa_s;
						7'd7	:	buzzer_counter_max <= reg_re_s;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[7]==1||KEY[8]==1)
						SW[6]<=0;	
				end

				if(KEY[7]==1)begin
					SW[7]<=1;
					reg_break<=0;end
				if(SW[7]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_do; 
						7'd1	:	buzzer_counter_max <= reg_mi;
						7'd2	:	buzzer_counter_max <= reg_sol;
						7'd3	:	buzzer_counter_max <= reg_high_do;
						7'd4	:	buzzer_counter_max <= reg_high_mi;
						7'd5	:	buzzer_counter_max <= reg_high_do;
						7'd6	:	buzzer_counter_max <= reg_sol;
						7'd7	:	buzzer_counter_max <= reg_mi;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[8]==1)
						SW[7]<=0;	
				end
	
				if(KEY[8]==1)begin
					SW[8]<=1;
					reg_break<=0;end
				if(SW[8]==1)
				begin
					case(status)                                            //8박 ->2초
						7'd0	:	buzzer_counter_max <= reg_re; 
						7'd1	:	buzzer_counter_max <= reg_pa_s;
						7'd2	:	buzzer_counter_max <= reg_ra;
						7'd3	:	buzzer_counter_max <= reg_high_re;
						7'd4	:	buzzer_counter_max <= reg_high_pa_s;
						7'd5	:	buzzer_counter_max <= reg_high_re;
						7'd6	:	buzzer_counter_max <= reg_ra;
						7'd7	:	buzzer_counter_max <= reg_pa_s;
					endcase
					if(status>7'd7||KEY[0]==1||KEY[1]==1||KEY[2]==1||KEY[3]==1||KEY[4]==1||KEY[5]==1||KEY[6]==1||KEY[7]==1)
						SW[8]<=0;	
				end
				
			end
			

			
		end//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end	
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)
		buzzer_counter <= 16'd0;
	else
		if(buzzer_counter > buzzer_counter_max)
			buzzer_counter <= 16'd0;
		else
			buzzer_counter <= buzzer_counter + 1;
end

always @ (posedge CLK or posedge RESET)
begin
	if(RESET)begin
		regBUZZER <= 1'b1;
	end
	else
		begin
			if(LEFT_K0==1 || LEFT_K1==1	||	(LEFT_K3==1 && Mode_Switch))
			begin
						if(SW[0]==0	&&	SW[1]==0	&&	SW[2]==0	&&	SW[3]==0	&&	SW[4]==0	&&	SW[5]==0	&&	SW[6]==0	&&	SW[7]==0	&&	SW[8]== 0 ||reg_break==1)
							regBUZZER <= 1'b1;
						else
						begin
							if(buzzer_counter == 16'd1)
								regBUZZER <= ~regBUZZER;
						end	
			end
			else if(LEFT_K3==1 && !Mode_Switch)
			begin
						if(KEY[8:0] == 0)
							regBUZZER <= 1'b1;
						else
						begin
							if(buzzer_counter == 16'd1)
								regBUZZER <= ~regBUZZER;
						end
						
			end
			else if(LEFT_K2==1)
			begin
						if((((Rec_on==1) && !(KEY[8:0]==0)) || Rec_play ==1) && reg_break==0)
						begin
							if(buzzer_counter == 16'd1)
								regBUZZER <= ~regBUZZER;
						end
						else
							regBUZZER <= 1'b1;
			end
			///////////////////////////////////////////////////////////////////////////////
		end
end

assign	BUZZER = regBUZZER;

endmodule
