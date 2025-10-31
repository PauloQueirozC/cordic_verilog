module vertice_calculator(
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
	
	output [9:0] v1_x,
	output [9:0] v1_y,
	output [9:0] v2_x,
	output [9:0] v2_y,
	output [9:0] v3_x,
	output [9:0] v3_y,
	output [9:0] v4_x,
	output [9:0] v4_y,
	output    	 out_form,
	output [8:0] out_st2_color,
   output [9:0] out_st2_pixel_x,
   output [9:0] out_st2_pixel_y,
   output 		 out_st2_bubble
	/*
	output reg [9:0] v1_x,
	output reg [9:0] v1_y,
	output reg [9:0] v2_x,
	output reg [9:0] v2_y,
	output reg [9:0] v3_x,
	output reg [9:0] v3_y,
	output reg [9:0] v4_x,
	output reg [9:0] v4_y,
	output reg		  out_form,
	output reg [8:0] out_st2_color,
   output reg [9:0] out_st2_pixel_x,
   output reg [9:0] out_st2_pixel_y,
   output reg 		  out_st2_bubble*/
);
	// Wires pipeline dos vetores
	wire [18:0] v1_x_nst1;
	wire [18:0] v1_y_nst1;
	wire [18:0] v2_x_nst1;
	wire [18:0] v2_y_nst1;
	wire [18:0] v3_x_nst1;
	wire [18:0] v3_y_nst1;
	wire [18:0] v4_x_nst1;
	wire [18:0] v4_y_nst1;
	
	// Wires pipeline do angle_z
	wire [8:0] angle_z_nst1;
	
	// Wires pipeline enable_cordic
	wire enable_cordic_nst1;
	
	// Wires pipeline form,
	wire    	 out_nst1_form;
	
	// Wires pipeline color
	wire [8:0] out_nst1_color;
	
	// Wires pipeline pixel
   wire [9:0] out_nst1_pixel_x;
   wire [9:0] out_nst1_pixel_y;
	
	//wire pipeline bolha
   wire 		  out_nst1_bubble;
	
	// Calculo inicial dos vetores
	init_cordic init_cordic_inst(
		.clk(clk),
		.reset(reset),
		.st2_bubble(st2_bubble),
		.st2_color(st2_color),
		.st2_pixel_x(st2_pixel_x),
		.st2_pixel_y(st2_pixel_y),
		.ref_point_x(ref_point_x),
		.ref_point_y(ref_point_y),
		.angle(angle),
		.form(form),
		.size(size),
		
		.v1_x(v1_x_nst1),
		.v1_y(v1_y_nst1),
		.v2_x(v2_x_nst1),
		.v2_y(v2_y_nst1),
		.v3_x(v3_x_nst1),
		.v3_y(v3_y_nst1),
		.v4_x(v4_x_nst1),
		.v4_y(v4_y_nst1),
		.angle_cordic(angle_z_nst1),
		.enable_cordic(enable_cordic_nst1),
		
		.out_form(out_st1_form),
		.out_st2_color(out_st1_color),
		.out_st2_pixel_x(out_nst1_pixel_x),
		.out_st2_pixel_y(out_nst1_pixel_y),
		.out_st2_bubble(out_nst1_bubble),
		.out_ref_point_x(out_ref_point_x),
		.out_ref_point_y(out_ref_point_y)
	);

endmodule