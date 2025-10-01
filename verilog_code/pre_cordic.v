module pre_cordic(c_Vx, c_Vy, c_Z, Vx, Vy, Z);
	input signed [10:0] Vx, Vy;
	input signed [8:0] Z;
	output reg signed [18:0] c_Vx, c_Vy;
	output reg signed [8:0] c_Z;
	
	wire signed [18:0] pf_Vx, pf_Vy;
	wire signed [18:0] s_Vx, s_Vy;
	
	cordic_prescale prescale_x(
		.sV(s_Vx),
		.V(Vx)
	);
	cordic_prescale prescale_y(
		.sV(s_Vy),
		.V(Vy)
	);
	
	always @(*) begin
		case (Z[8:7])
			2'b01: begin
				c_Vx = -s_Vy;
				c_Vy =  s_Vx;
				c_Z  =  Z - 9'b010000000;
			end
			2'b10: begin
				c_Vx =  s_Vy;
				c_Vy = -s_Vx;
				c_Z  =  Z + 9'b010000000;
			end
			default: begin
				c_Vx =  s_Vx;
				c_Vy =  s_Vy;
				c_Z  =  Z;
			end
		endcase
	end
endmodule
