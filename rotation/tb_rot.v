`timescale 1ns / 1ps

//http://web.cs.ucla.edu/digital_arithmetic/files/ch11.pdf
//1.64676
module tb_rot();
    parameter data_width = 16;
    parameter cordic_steps = 16;
    parameter angle_width = 20;
    
    reg clk;
    reg nreset;
    reg enable;
    reg signed [data_width-1:0] x_vec_in;
    reg signed [data_width-1:0] y_vec_in;
    reg [angle_width-1:0] target_angle;
    
    wire signed [data_width-1:0] x_vec_out;
    wire signed [data_width-1:0] y_vec_out;
    wire done;
    
    cordic_rotation_top #(
        .data_width(data_width),
        .cordic_steps(cordic_steps),
        .angle_width(angle_width)
    )
    cordic_rotation(
        .clk(clk),
        .nreset(nreset),
        .enable(enable),
        .x_vec_in(x_vec_in),
        .y_vec_in(y_vec_in),
        .target_angle(target_angle),
        .x_vec_out(x_vec_out),
        .y_vec_out(y_vec_out),
        .done(done)
        );
    
    always begin
        #5 clk <= !clk;
    end
    
    initial begin
		  clk <= 1;
		  enable <= 1'b0;
        #10
        enable <= 1'b1;
        nreset <= 1'b1;
        x_vec_in <= 'b0000000101101001;
        y_vec_in <= 'b0000000000000000;
        target_angle <= 20'h02000;
        
        #20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000000000000;
        target_angle <= 20'h01800;
		
		#20
		x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= 20'h02200;
		
		#20
		x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= 20'h10000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= 20'h0D000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= 20'h0A000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= 20'h06000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= -20'h10000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= -20'h0D000;
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= -20'h0A000;
		$display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        x_vec_in <= 'b0000000100000000;
        y_vec_in <= 'b0000000110000000;
        target_angle <= -20'h06000;
		$display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        x_vec_in <= 257;
        y_vec_in <= 0;
        target_angle <= 24571;
		$display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        x_vec_in <= 256;
        y_vec_in <= 0;
        target_angle <= 11851;
		$display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
        
        #20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
		
		#20
        $display("Xout: %d   , Yout: %d   ",x_vec_out,y_vec_out);
        
//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= 20'h02200;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= 20'h10000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= 20'h0D000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);
                

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= 20'h0A000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= 20'h06000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);


//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= -20'h10000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= -20'h0D000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);
                

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= -20'h0A000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 'b0000000100000000;
//        y_vec_in <= 'b0000000110000000;
//        target_angle <= -20'h06000;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 257;
//        y_vec_in <= 0;
//        target_angle <= 24571;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

//        #10
//        x_vec_in <= 256;
//        y_vec_in <= 0;
//        target_angle <= 11851;
//        #300
//        $display("Xin: %d   , Yin : %d   ,   Angle : %d   , Xout: %d   , Yout: %d   ,",x_vec_in,y_vec_in,target_angle,x_vec_out,y_vec_out);

        $finish;
        end
    
endmodule
