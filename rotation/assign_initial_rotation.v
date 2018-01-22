`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2017 08:14:43 PM
// Design Name: 
// Module Name: assign_initial_rotation
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


module stages_rotation #(parameter data_width=16,angle_width=16,cordic_steps=16,stage_number=1)(
    input clk,
    input nreset,
    input enable,
    
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    
    input signed [angle_width-1:0]angle_in,
    input signed [angle_width-1:0]target_angle,
    
    output signed [data_width-1:0] x_vec_out,
    output signed [data_width-1:0] y_vec_out,
    
    output reg signed [angle_width-1:0]angle_out,
    output reg signed [angle_width-1:0]target_angle_out,
    output reg done
    );
    
    wire signed [angle_width-1:0] atan [cordic_steps-1:0];
    
    assign atan[0] = 20'h02000;// pi/4
    assign atan[1] = 20'h012E4;
    assign atan[2] = 20'h009FB;
    assign atan[3] = 20'h00511;
    assign atan[4] = 20'h0028B;
    assign atan[5] = 20'h00145;
    assign atan[6] = 20'h000A2;
    assign atan[7] = 20'h00051;
    assign atan[8] = 20'h00028;
    assign atan[9] = 20'h00014;
    assign atan[10] = 20'h0000A;
    assign atan[11] = 20'h00005;
    assign atan[12] = 20'h00002;
    assign atan[13] = 20'h00001;
    assign atan[14] = 20'h00000;
    assign atan[15] = 20'h00000;

    reg signed [data_width-1:0]x_temp_out,y_temp_out;
    //reg [angle_width-1:0]temp_angle_out;
    
    assign x_vec_out = x_temp_out;
    assign y_vec_out = y_temp_out;
    
    always @(posedge clk) begin
        if (~nreset) begin
            x_temp_out <= $signed({data_width{1'b0}});
            y_temp_out <= $signed({data_width{1'b0}});
				angle_out <= 0;
            //temp_angle_out <= {angle_width{1'b0}};
            done <= 1'b0;
        end
        else begin
            if (enable) begin
                if ($signed(target_angle) <= $signed(angle_in)) begin
                    x_temp_out <= x_vec_in + (y_vec_in>>>(stage_number-1));
                    y_temp_out <= y_vec_in - (x_vec_in>>>(stage_number-1));
                    angle_out <= angle_in - atan[stage_number-1];
                end
                else begin
                    x_temp_out <= x_vec_in - (y_vec_in>>>(stage_number-1));
                    y_temp_out <= y_vec_in + (x_vec_in>>>(stage_number-1));
                    angle_out <= angle_in + atan[(stage_number-1)];
                end
                target_angle_out <= target_angle;
                done <= 1'b1;
            end
            else begin
                x_temp_out <= $signed({data_width{1'b0}});
                y_temp_out <= $signed({data_width{1'b0}});
					 angle_out <= 0;
                //temp_angle_out <= {angle_width{1'b0}};
                done <= 1'b0;
            end
        end
    end
    
endmodule
