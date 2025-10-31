`define theta_0 9'd64 // atan(2^0) = 45°    -> (45/360)*512 = 64
`define theta_1 9'd38 // atan(2^-1)= 26.56° -> (26.56/360)*512 = 38
`define theta_2 9'd20 // atan(2^-2)= 14.04° -> (14.04/360)*512 = 20
`define theta_3 9'd10 // atan(2^-3)= 7.12°  -> (7.12/360)*512 = 10
`define theta_4 9'd5  // atan(2^-4)= 3.58°  -> (3.58/360)*512 = 5
`define theta_5 9'd3  // atan(2^-5)= 1.79°  -> (1.79/360)*512 = 3
`define theta_6 9'd1  // atan(2^-6)= 0.90°  -> (0.90/360)*512 = 1
`define theta_7 9'd0  // atan(2^-7)= 0.45°  -> (0.45/360)*512 = 0


module cordic_seq(R_Vx, R_Vy, Vx, Vy, Z0);
	input signed [10:0] Vx, Vy;
	input signed [8:0] Z0;
	output signed [10:0] R_Vx, R_Vy;
	
	//Tabela de Angulos
	wire signed [8:0] atan_table [0:7];

   assign atan_table[0] = `theta_0;
   assign atan_table[1] = `theta_1;
   assign atan_table[2] = `theta_2;
   assign atan_table[3] = `theta_3;
   assign atan_table[4] = `theta_4;
   assign atan_table[5] = `theta_5;
   assign atan_table[6] = `theta_6;
   assign atan_table[7] = `theta_7;
	
	//Iteraçoes
	wire signed [18:0] Vx_stages [0:8];
	wire signed [18:0] Vy_stages [0:8];
	wire signed [8:0]  Z_stages  [0:8];
	
	assign R_Vx = (Vx_stages[8][18] ? (Vx_stages[8] >>> 8)+1 : Vx_stages[8] >>> 8);
	assign R_Vy = (Vy_stages[8][18] ? (Vy_stages[8] >>> 8)+1 : Vy_stages[8] >>> 8);
	
	pre_cordic pre_cordic(
		.c_Vx(Vx_stages[0]), 
		.c_Vy(Vy_stages[0]), 
		.c_Z(Z_stages[0] ), 
		.Vx(Vx), 
		.Vy(Vy), 
		.Z(Z0)
	);
	
	genvar i;

	generate
		 for (i = 0; i < 8; i = i + 1) begin : cordic_iterations
			  cordic_unit cordic_iter_inst (
					.RVx(Vx_stages[i+1]),
					.RVy(Vy_stages[i+1]),
					.new_Z(Z_stages[i+1]),
					.Vx(Vx_stages[i]),
					.Vy(Vy_stages[i]),
					.Z(Z_stages[i]),
					.i(i),
					.atan(atan_table[i])
			  );
			  
		 end
	endgenerate
endmodule