
//create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]
//report_timing -from [get_registers {A_reg[*]}] -to [get_registers {S_reg[*]}] -setup -npaths 10 -detail full_path -panel_name "Atraso Interno do DSP"

module teste_cordic_unit(
  input clk,
  input [10:0] Vx, Vy, 
  output [10:0] Sx, Sy
);
	reg [10:0] Vx_reg, Vy_reg;
	always @(posedge clk) begin
		Vx_reg <= Vx;
		Vy_reg <= Vy;
	end
	
	wire [10:0] Sx_comb, Sy_comb;
	cordic_seq inst(
		.R_Vx(Sx_comb), 
		.R_Vy(Sy_comb), 
		.Vx(Vx_reg), 
		.Vy(Vy_reg), 
		.Z0(9'd64)
		);
	
	
					
	reg [10:0] Sx_reg, Sy_reg;
	always @(posedge clk) begin
		Sx_reg <= Sx_comb;
		Sy_reg <= Sy_comb;
	end
  
	assign Sx = Sx_reg;
	assign Sy = Sy_reg;
endmodule
