`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2017 08:30:12 AM
// Design Name: 
// Module Name: tb_cordic_vectoring
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_cordic_vectoring();
    parameter data_width = 16;
    parameter cordic_steps = 16;
    parameter angle_width = 20;
    
    reg clk;
    reg nreset;
    reg enable;
    reg signed [data_width-1:0]x_vec_in;
    reg signed [data_width-1:0]y_vec_in;
    
    wire signed [data_width-1:0]x_vec_out;
    wire [cordic_steps-1:0] micro_rotation;
    wire [angle_width-1:0] angle;
    
    cordic_vectoring_top #(
        .data_width(data_width),
        .cordic_steps(cordic_steps),
        .angle_width(angle_width)
    )
    MAIN(
        .clk(clk),
        .nreset(nreset),
        .enable(enable),
        .x_vec_in(x_vec_in),
        .y_vec_in(y_vec_in),
        .x_vec_out(x_vec_out),
        .micro_rotation(micro_rotation),
        .angle(angle)
        );
    
    always begin
        #5 clk <= !clk;
    end
    
    initial begin
        clk <= 1;
		  nreset=0;
		  #10
		  nreset=1;
//      
        #10
        enable <= 1'b1;
        nreset <= 1'b1;
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000100000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000010000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= 'b0000010100000000;
        y_vec_in <= 'b0000000110000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= ~'b0000000010000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= ~'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        
        #10
        x_vec_in <= ~'b0000010100000000;
        y_vec_in <= ~'b0000000110000000;
        #300
        $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
        #10
		  x_vec_in <= -181;
		  y_vec_in <= 181;
		  #300
		  $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
		  #10
		  x_vec_in <= 108;
		  y_vec_in <= 232;
		  #300
		  $display("Xin: %d   , Yin : %d   ,   Xout: %d   ,  Angle : %d   ",x_vec_in,y_vec_in,x_vec_out,$signed(angle));
		  $finish;
    end
endmodule
