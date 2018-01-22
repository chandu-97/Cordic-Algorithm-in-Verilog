`timescale 1ns / 1ps

module cordic_rotation_top#(parameter data_width=16,cordic_steps=16,angle_width=20)(
    input clk,
    input nreset,
    input enable,
    input signed [data_width-1:0] x_vec_in,
    input signed [data_width-1:0] y_vec_in,
    input [angle_width-1:0] target_angle,
    output wire signed  [data_width-1:0] x_vec_out,
    output wire signed  [data_width-1:0] y_vec_out,
    output reg done
    );
    
    wire signed [data_width-1:0] x [0:cordic_steps-1];
    wire signed [data_width-1:0] y [0:cordic_steps-1];
    wire signed [angle_width-1:0] angle_stages [0:cordic_steps-1];
    wire [1:cordic_steps] status;
    
	 reg signed [data_width-1+16:0] temp_x_vec_out,temp_y_vec_out;
	 wire done_last_stage;
	 
	 reg signed [data_width-1:0] temp_x_vec_in,temp_y_vec_in;
	 reg [angle_width-1:0]temp_t_ang;
	 wire signed [angle_width-1:0] temp_target_angle [0:cordic_steps-1];
	 reg temp_enable;
	 
	 always @(posedge clk) begin
		if(~nreset) begin
			temp_x_vec_in <= {data_width{1'b0}};
			temp_y_vec_in <= {data_width{1'b0}};
			temp_t_ang <= {angle_width{1'b0}};
			temp_enable <= 1'b0;
		end
		else begin
			if (enable) begin
				temp_enable <= 1'b1;				
				if ($signed(target_angle)>=$signed(20'h04000)) begin
				    if ($signed(target_angle)>=$signed(20'h08000)) begin
				        if ($signed(target_angle)>=$signed(20'h0C000)) begin
				            temp_x_vec_in <= x_vec_in;
                            temp_y_vec_in <= y_vec_in;
                            temp_t_ang <= $signed(target_angle) - $signed(20'h10000);
   				        end
				        else begin
				            temp_x_vec_in <= -x_vec_in;
                            temp_y_vec_in <= -y_vec_in;
                            temp_t_ang <= $signed(target_angle) - $signed(20'h08000);
				        end
				    end
				    else begin
                        temp_x_vec_in <= -x_vec_in;
                        temp_y_vec_in <= -y_vec_in;
                        temp_t_ang <= $signed(target_angle) - $signed(20'h08000);
  				    end
				end
                else if ($signed(target_angle)<=$signed(-20'h04000)) begin
                    if ($signed(target_angle)<=$signed(-20'h08000)) begin
                        if ($signed(target_angle)<=$signed(-20'h0C000)) begin
				            temp_x_vec_in <= x_vec_in;
                            temp_y_vec_in <= y_vec_in;
                            temp_t_ang <= $signed(target_angle) + $signed(20'h10000);
                        end
                        else begin
				            temp_x_vec_in <= -x_vec_in;
                            temp_y_vec_in <= -y_vec_in;
                            temp_t_ang <= $signed(target_angle) + $signed(20'h08000);
                        end
                    end
                    else begin
                        temp_x_vec_in <= -x_vec_in;
                        temp_y_vec_in <= -y_vec_in;
                        temp_t_ang <= $signed(target_angle) + $signed(20'h08000);
                    end
                end
				else begin
					temp_x_vec_in <= x_vec_in;
					temp_y_vec_in <= y_vec_in;
					temp_t_ang <= $signed(target_angle);
				end
			end
			else begin
				temp_enable <= 1'b0;
				temp_x_vec_in <= {data_width{1'b0}};
				temp_y_vec_in <= {data_width{1'b0}};
				temp_t_ang <= {angle_width{1'b0}};
			end
		end
	 end
	 
    assign status[1] = temp_enable;
    assign x[0] = temp_x_vec_in;
    assign y[0] = temp_y_vec_in;
    assign angle_stages[0] = {angle_width{1'b0}};
    assign temp_target_angle[0] = temp_t_ang;
    
    genvar i;
    
    generate
        for (i=1;i<cordic_steps-1;i=i+1) begin:gen_rotation
            stages_rotation #(
                .data_width(data_width),
                .angle_width(angle_width),
                .cordic_steps(cordic_steps),
                .stage_number(i)
                )
            first(
                .clk(clk),
                .nreset(nreset),
                .enable(status[i]),
                
                .x_vec_in(x[i-1]),
                .y_vec_in(y[i-1]),
                
                .angle_in(angle_stages[i-1]),
                .target_angle(temp_target_angle[i-1]),
                
                .x_vec_out(x[i]),
                .y_vec_out(y[i]),
                
                .angle_out(angle_stages[i]),
                .target_angle_out(temp_target_angle[i]),
                .done(status[i+1])
                );
        end
    endgenerate
    
    stages_rotation #(
        .data_width(data_width),
        .angle_width(angle_width),
        .cordic_steps(cordic_steps),
        .stage_number(cordic_steps-1)
        )
    last(
        .clk(clk),
        .nreset(nreset),
        .enable(status[cordic_steps-2]),
        
        .x_vec_in(x[cordic_steps-2]),
        .y_vec_in(y[cordic_steps-2]),
        
        .angle_in(angle_stages[cordic_steps-2]),
        .target_angle(temp_target_angle[cordic_steps-2]),
        
        .x_vec_out(x[cordic_steps-1]),
        .y_vec_out(y[cordic_steps-1]),
        
        .angle_out(angle_stages[cordic_steps-1]),
        .target_angle_out(temp_target_angle[cordic_steps-1]),
        
        .done(done_last_stage)
        );
    reg counter;
	assign x_vec_out = temp_x_vec_out[data_width+7:8];
	assign y_vec_out = temp_y_vec_out[data_width+7:8];
	 always @(posedge clk) begin
        if (~nreset) begin
            done <= 1'b0;
        end
        else begin
            if (done_last_stage) begin
                    temp_x_vec_out <= $signed(x[cordic_steps-1])*$signed(16'b0000000010011011);
                    temp_y_vec_out <= $signed(y[cordic_steps-1])*$signed(16'b0000000010011011);
                    done <= 1'b1;
            end
        end
    end
	 
endmodule
