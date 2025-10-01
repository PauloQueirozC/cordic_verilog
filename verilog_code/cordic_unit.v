module cordic_unit(RVx, RVy, new_Z, Vx, Vy, Z, i, atan);
	input signed [8:0] Z, atan;
	input signed [18:0] Vx, Vy;
	input [2:0] i;
	output reg signed [8:0] new_Z;
	output reg signed [18:0] RVx, RVy;
	
	reg signed [18:0] dx, dy;
	always @(*) begin
		dx = Vy >>> i;
		dy = Vx >>> i;
		if (Z[8]) begin
			RVx = Vx + dx;
			RVy = Vy - dy;
			new_Z = Z + atan;
		end else begin
			RVx = Vx - dx;
			RVy = Vy + dy;
			new_Z = Z - atan;
		end
	end
endmodule