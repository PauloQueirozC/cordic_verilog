
//create_clock -name {meu_clk} -period 10.0 [get_ports {clk}]
//report_timing -from [get_registers {A_reg[*]}] -to [get_registers {S_reg[*]}] -setup -npaths 10 -detail full_path -panel_name "Atraso Interno do DSP"

module teste_cordic_unit(
	input wire       clk,
	input wire       reset,
	input wire       st2_bubble,
	input wire [8:0] st2_color,
	input wire [9:0] st2_pixel_x,
	input wire [9:0] st2_pixel_y,
	input wire [8:0] ref_point_x,
	input wire [8:0] ref_point_y,
	input wire signed [8:0] angle,
	input wire 		  form,
	input wire [6:0] size,
	
	output signed [18:0] v1_x,
	output signed [18:0] v1_y,
	output signed [18:0] v2_x,
	output signed [18:0] v2_y,
	output signed [18:0] v3_x,
	output signed [18:0] v3_y,
	output signed [18:0] v4_x,
	output signed [18:0] v4_y,
	output signed [8:0]  angle_cordic,
	output 					enable_cordic,
	
	output		 out_form,
	output [8:0] out_st2_color,
   output [9:0] out_st2_pixel_x,
   output [9:0] out_st2_pixel_y,
   output 		 out_st2_bubble,
	output [8:0] out_ref_point_x,
	output [8:0] out_ref_point_y
);

	reg               st2_bubble_reg;
	reg 			[8:0] st2_color_reg;
	reg 			[9:0] st2_pixel_x_reg;
	reg 			[9:0] st2_pixel_y_reg;
	reg 			[8:0] ref_point_x_reg;
	reg 			[8:0] ref_point_y_reg;
	reg signed 	[8:0] angle_reg;
	reg 		 			form_reg;
	reg 			[6:0] size_reg;
	
	always @(posedge clk) begin
		st2_bubble_reg <= st2_bubble;
		st2_color_reg <= st2_color;
		st2_pixel_x_reg <= st2_pixel_x;
		st2_pixel_y_reg <= st2_pixel_y;
		ref_point_x_reg <= ref_point_x;
		ref_point_y_reg <= ref_point_y;
		angle_reg <= angle;
		form_reg <= form;
		size_reg <= size;
	end
	
	wire [10:0] Sx_comb, Sy_comb;
	init_cordic init_cordic_inst(
		.clk(clk),
		.reset(reset),
		.st2_bubble(st2_bubble_reg),
		.st2_color(st2_color_reg),
		.st2_pixel_x(st2_pixel_x_reg),
		.st2_pixel_y(st2_pixel_y_reg),
		.ref_point_x(ref_point_x_reg),
		.ref_point_y(ref_point_y_reg),
		.angle(angle_reg),
		.form(form_reg),
		.size(size_reg),
		
		.v1_x(v1_x),
		.v1_y(v1_y),
		.v2_x(v2_x),
		.v2_y(v2_y),
		.v3_x(v3_x),
		.v3_y(v3_y),
		.v4_x(v4_x),
		.v4_y(v4_y),
		.angle_cordic(angle_cordic),
		.enable_cordic(enable_cordic),
		
		.out_form(out_form),
		.out_st2_color(out_st2_color),
		.out_st2_pixel_x(out_st2_pixel_x),
		.out_st2_pixel_y(out_st2_pixel_y),
		.out_st2_bubble(out_st2_bubble),
		
		.out_ref_point_x(out_ref_point_x),
		.out_ref_point_y(out_ref_point_y)
	);

endmodule
