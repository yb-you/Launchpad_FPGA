`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:02:32 08/16/2018 
// Design Name: 
// Module Name:    top 
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
module top(
	input clock_12MHz,
	input RESET,
	input Mode_Switch,
	
	input [8:0] KEY,
	input [3:0] LEFT_KEY,
	
	output wire [7:0] LED,
	output wire [3:0] FND_COM,
	output wire [7:0] FND_DATA,
	output wire [9:0] DOT_COL,
	output wire [13:0] DOT_RAW,
	
	output wire			LCD_RS,
	output wire			LCD_RW,
	output wire			LCD_EN,
	output wire	[7:0]		LCD_DATA,
	output wire [3:0] MOTOR_OUT,
	output wire			BUZZER
); 

wire clock_24MHz;

PLL24X2 PLL24X2(
	.RESET(RESET),
	.CLK_IN1(clock_12MHz),
	.CLK_OUT1(clock_24MHz)
);

led_ctrl led_ctrl(
	.RESET(SystemRESET_Reset),
	.CLK(clock_24MHz),
	.Mode_Switch(Mode_Switch),
	.KEY(KEY),
	.LED(LED),
	.LEFT_KEY(LEFT_KEY)
);
	
segment segment(
	.RESET(RESET),
	.Mode_Switch(Mode_Switch),
	.KEY(KEY),
	.CLK(clock_24MHz),
	.FND_COM(FND_COM),
	.FND_DATA(FND_DATA)
);

dot dot(
	.RESET(RESET),
	.CLK(clock_24MHz),
	.DOT_COL(DOT_COL),
	.DOT_RAW(DOT_RAW),
	.KEY(KEY),
	.Mode_Switch(Mode_Switch),
	.LEFT_KEY(LEFT_KEY)
);

//textlcd   
textlcd textlcd(
	.RESET(RESET),
	.CLK(clock_24MHz),
	.LCD_RS(LCD_RS),
	.LCD_RW(LCD_RW),
	.LCD_EN(LCD_EN),
	.LCD_DATA(LCD_DATA),
	.LEFT_KEY(LEFT_KEY),
	.Mode_Switch(Mode_Switch)
);

//stepmotor
motor motor(
	.RESET(RESET),
	.Mode_Switch(Mode_Switch),
	.CLK(clock_24MHz),
	.LEFT_KEY(LEFT_KEY),
	.MOTOR_OUT(MOTOR_OUT),
	.KEY(KEY)
);

piezo piezo(
	.RESET(RESET),
	.CLK(clock_24MHz),
	.KEY(KEY),
	.BUZZER(BUZZER),
	.LEFT_KEY(LEFT_KEY),
	.Mode_Switch(Mode_Switch)
);
endmodule

