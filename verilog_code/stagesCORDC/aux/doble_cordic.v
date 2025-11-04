module doble_cordic(
	output wire signed	[18:0]	RVx, RVy, 
	output wire signed 	[8:0]		new_Z,
	
	input wire signed 	[18:0]	Vx, Vy,
	input wire signed 	[8:0]		Z, atan0, atan1,
	input wire signed 	[2:0]		i
);
	wire signed [18:0]	stp_Vx, stp_Vy;
	wire signed [8:0]		stp_z;
	
	cordic_unit stp1_cordic(
		.RVx(stp_Vx),
		.RVy(stp_Vy), 
		.new_Z(stp_z), 
		.Vx(Vx), 
		.Vy(Vy), 
		.Z(Z), 
		.i(i), 
		.atan(atan0)
	);
	
	cordic_unit stp2_cordic(
		.RVx(RVx),
		.RVy(RVy), 
		.new_Z(new_Z), 
		.Vx(stp_Vx), 
		.Vy(stp_Vy), 
		.Z(stp_z), 
		.i(i+1), 
		.atan(atan1)
	);
	
	
endmodule