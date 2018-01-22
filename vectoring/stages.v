`timescale 1ns / 1ps

module stages #(parameter rotation_stage = 1,data_width=16,cordic_steps=16)(
    input clk,
    input nreset,
    input enable,
    
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    input [cordic_steps-1:0] micro_rotation_in,
    input [1:0] quad_in,
    
    output signed [data_width-1:0] x_vec_out,
    output signed [data_width-1:0] y_vec_out,
    output reg [cordic_steps-1:0] micro_rotation_out,
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
            micro_rotation_out <= 1'b0;
            done <= 1'b0;
        end
        else begin
            if (enable) begin
                done <= 1'b1;
                if (!y_vec_in[data_width-1]) begin
                    x_temp_out <= x_vec_in + (y_vec_in>>>rotation_stage);
                    y_temp_out <= y_vec_in - (x_vec_in>>>rotation_stage);
                    micro_rotation_out <= {{(cordic_steps-1-rotation_stage){1'b0}},1'b1,micro_rotation_in[rotation_stage-1:0]};
                end
                else begin
                    x_temp_out <= x_vec_in - (y_vec_in>>>rotation_stage);
                    y_temp_out <= y_vec_in + (x_vec_in>>>rotation_stage);
                    micro_rotation_out <= {{(cordic_steps-1-rotation_stage){1'b0}},1'b0,micro_rotation_in[rotation_stage-1:0]};
                end
                quad_out <= quad_in;
            end
            else begin
                done <= 1'b0;
            end
        end
    end
endmodule
