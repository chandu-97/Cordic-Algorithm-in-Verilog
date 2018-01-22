`timescale 1ns / 1ps

module micro_to_angle #(parameter cordic_steps=16,angle_width=16)(
    input clk,
    input nreset,
    input enable,
    input [1:0]quadrant,
    input [cordic_steps-1:0]micro_rotation,
    output reg signed [angle_width-1:0]angle_out,
    output reg done
    );
    
//    parameter counter_width = $clog2(cordic_steps);
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
    
    wire signed [angle_width-1:0]angle_temp;
    
    assign angle_temp = (micro_rotation[0]?atan[0]:$signed(-atan[0])) + (micro_rotation[1]?atan[1]:$signed(-atan[1])) + (micro_rotation[2]?atan[2]:$signed(-atan[2])) + 
    (micro_rotation[3]?atan[3]:$signed(-atan[3])) + (micro_rotation[4]?atan[4]:$signed(-atan[4])) + (micro_rotation[5]?atan[5]:$signed(-atan[5])) +
    (micro_rotation[6]?atan[6]:$signed(-atan[6])) + (micro_rotation[7]?atan[7]:$signed(-atan[7])) + (micro_rotation[8]?atan[8]:$signed(-atan[8])) +
    (micro_rotation[9]?atan[9]:$signed(-atan[9])) + (micro_rotation[10]?atan[10]:$signed(-atan[10])) + (micro_rotation[11]?atan[11]:$signed(-atan[11])) +
    (micro_rotation[12]?atan[12]:$signed(-atan[12])) + (micro_rotation[13]?atan[13]:$signed(-atan[13])) + (micro_rotation[14]?atan[14]:$signed(-atan[14])) +
    (micro_rotation[15]?atan[15]:$signed(-atan[15]));
    
    always @(posedge clk) begin
        if (~nreset) begin
            angle_out <= {angle_width{1'b0}};
            done <= 1'b0;
        end
        else begin
            if (enable) begin
                if (quadrant == 2'b11) begin
                    angle_out <= $signed(angle_temp) - $signed(20'h08000);
                end
                else if (quadrant == 2'b10) begin
                    angle_out <= $signed(20'h08000) + $signed(-angle_temp);
                end
                else if (quadrant == 2'b01) begin
                    angle_out <= $signed(-angle_temp);
                end
                else begin
                    angle_out <= angle_temp;
                end
                done <= 1'b1;
            end
            else begin
                done <= 1'b0;
            end
        end
    end
endmodule
