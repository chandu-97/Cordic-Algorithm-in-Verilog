`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2017 07:25:47 AM
// Design Name: 
// Module Name: cordic_vectoring_top
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


module cordic_vectoring_top #(parameter data_width=16,cordic_steps=16,angle_width=20)(
    input clk,
    input nreset,
    input enable,
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    output wire signed [data_width-1:0] x_vec_out,
    output [cordic_steps-1:0] micro_rotation,
    output reg signed [angle_width-1:0] angle,
    output reg done
    );
    
    wire signed [data_width-1:0] x [0:cordic_steps];
    wire signed [data_width-1:0] y [0:cordic_steps];
    wire [0:cordic_steps-1] status;
    wire quad_out;
    wire [1:0] quadrant [0:cordic_steps];
    wire done_angle_conversion;
    wire signed [angle_width-1:0] temp_angle;
    
    reg counter=0;
    reg signed [data_width-1+16:0] temp_x_vec_out=0;
    
    wire signed [data_width-1:0] temp_x_vec_in;
    wire signed [data_width-1:0] temp_y_vec_in;
    wire [cordic_steps-1:0]temp_micro_rotation[cordic_steps-1:0];
    assign x[0] = temp_x_vec_in;
    assign y[0] = temp_y_vec_in;
    assign micro_rotation = temp_micro_rotation[cordic_steps-1];
    
    vectoring_quadrant_init#(16)
    quad(
        .clk(clk),
        .enable(enable),
        .nreset(nreset),
        .x_vec_in(x_vec_in),
        .y_vec_in(y_vec_in),
        
        .done(quad_out),
        .x_vec_out(temp_x_vec_in),
        .y_vec_out(temp_y_vec_in),
        .quadrant(quadrant[0])
        );
    
    assign_inital INITIAL(
        .clk(clk),
        .nreset(nreset),
        .enable(quad_out),
        .x_vec_in(x[0]),
        .y_vec_in(y[0]),
        .quad_in(quadrant[0]),
        .x_vec_out(x[1]),
        .y_vec_out(y[1]),
        .quad_out(quadrant[1]),
        .micro_rotation_out(temp_micro_rotation[0]),
        .done(status[0])
        );
        
    genvar i;
    generate
        for (i=1;i<cordic_steps;i=i+1) begin:gen_vectoring
            stages #(
                .data_width(data_width),
                .rotation_stage(i),
                .cordic_steps(cordic_steps)
            )
            STAGE(
                .clk(clk),
                .nreset(nreset),
                .enable(status[i-1]),
                .x_vec_in(x[i]),
                .y_vec_in(y[i]),
                .quad_in(quadrant[i]),
                .micro_rotation_in(temp_micro_rotation[i-1]),
                .x_vec_out(x[i+1]),
                .y_vec_out(y[i+1]),
                .quad_out(quadrant[i+1]),
                .micro_rotation_out(temp_micro_rotation[i]),
                .done(status[i])
                );
        end
    endgenerate
    
    micro_to_angle #(
        .cordic_steps(cordic_steps),
        .angle_width(angle_width)
    )
    angle_conversion(
        .clk(clk),
        .nreset(nreset),
        .enable(enable),
        .micro_rotation(temp_micro_rotation[cordic_steps-1]),
        .quadrant(quadrant[cordic_steps]),
        .angle_out(temp_angle),
        .done(done_angle_conversion)
        );
    assign x_vec_out = temp_x_vec_out[data_width+7:8];
    always @(posedge clk) begin
        if (~nreset) begin
            done <= 1'b0;
            //counter <= 1'b0;
        end
        else begin
            if (done_angle_conversion) begin
                //if (~counter) begin
                    temp_x_vec_out <= x[cordic_steps]*(16'b0000000010011011);
                    //counter <= 1'b1;
                    //done <= 1'b0;
                //end
                //else begin
                    //x_vec_out <= temp_x_vec_out[data_width+7:8];
                    angle <= temp_angle;
                    done <= 1'b1;
                    //counter <= 1'b0;
                //end
            end
	    //else begin
		//counter <= 1'b0;
		//end
        end
    end
endmodule
