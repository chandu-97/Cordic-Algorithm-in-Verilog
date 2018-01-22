`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2017 06:29:11 PM
// Design Name: 
// Module Name: vectoring_quadrant_init
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


module vectoring_quadrant_init#(parameter data_width=16)(
    input clk,
    input enable,
    input nreset,
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    
    output reg done,
    output reg signed [data_width-1:0] x_vec_out,
    output reg signed [data_width-1:0] y_vec_out,
    output reg [1:0]quadrant
    );
    
    always @(posedge clk) begin
        if (~nreset) begin
            x_vec_out <= {data_width{1'b0}};
            y_vec_out <= {data_width{1'b0}};
            quadrant <= 2'b00;
            done <= 1'b1;
        end
        else begin
            if (enable) begin
                if (x_vec_in[data_width-1]==1'b1) begin
                    if (y_vec_in[data_width-1]==1'b1) begin
                        x_vec_out <= -x_vec_in;
                        y_vec_out <= -y_vec_in;
                        quadrant <= 2'b11;
                    end
                    else begin
                        x_vec_out <= -x_vec_in;
                        y_vec_out <= y_vec_in;
                        quadrant <= 2'b10;
                    end
                end
                else begin
                    if (y_vec_in[data_width-1]==1'b1) begin
                        x_vec_out <= x_vec_in;
                        y_vec_out <= -y_vec_in;
                        quadrant <= 2'b01;
                    end
                    else begin
                        x_vec_out <= x_vec_in;
                        y_vec_out <= y_vec_in;
                        quadrant <= 2'b00;
                    end
                end
                done <= 1'b1;
            end
            else begin
                x_vec_out <= {data_width{1'b0}};
                y_vec_out <= {data_width{1'b0}};
                quadrant <= 2'b00;
                done <= 1'b1;
            end
        end
    end
endmodule
