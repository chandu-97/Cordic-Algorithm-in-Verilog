`timescale 1ns / 1ps

module assign_inital #(parameter data_width=16,cordic_steps=16)(
    input clk,
    input nreset,
    input enable,
    
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    input [1:0] quad_in,
    
    output signed [data_width-1:0] x_vec_out,
    output signed [data_width-1:0] y_vec_out,
    output reg [cordic_steps-1:0]micro_rotation_out,
    output reg [1:0] quad_out,
    
    output reg done
    );
    
    reg [data_width-1:0]x_temp_out,y_temp_out;
    
    assign x_vec_out = x_temp_out;
    assign y_vec_out = y_temp_out;
        
    always @(posedge clk or negedge nreset) begin
        if (~nreset) begin
            x_temp_out <= {data_width{1'b0}};
            y_temp_out <= {data_width{1'b0}};
            micro_rotation_out <= {cordic_steps{1'b0}};
            done <= 1'b0;
        end
        else begin
            if (enable) begin
                x_temp_out <= x_vec_in + y_vec_in;
                y_temp_out <= y_vec_in - x_vec_in;
                micro_rotation_out <= {{(cordic_steps-1){1'b0}},1'b1};
                quad_out <= quad_in;
                done <= 1'b1;
            end
            else begin
                done <= 1'b0;
            end
        end
    end
    
endmodule
