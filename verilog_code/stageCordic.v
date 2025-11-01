module stageCordic(
	input	wire	clk,
	input wire	reset,
	
	input wire				nst3_bubble,
	input wire	[8:0] 	nst3_color,
	input wire	[9:0]		nst3_pixel_x,
	input wire	[9:0]		nst3_pixel_y,
	input wire	[8:0]		nst3_ref_point_x,
	input wire	[8:0]		nst3_ref_point_y,
	input	wire				nst3_form,
	input wire	signed	[18:0]	nst3_v1_x,
	input wire	signed	[18:0]	nst3_v1_y,
	input wire	signed	[18:0]	nst3_v2_x,
	input wire	signed	[18:0]	nst3_v2_y,
	input wire	signed	[18:0]	nst3_v3_x,
	input wire	signed	[18:0]	nst3_v3_y,
	input wire	signed	[18:0]	nst3_v4_x,
	input wire	signed	[18:0]	nst3_v4_y,
	input wire	signed	[8:0]		nst3_z,
	input wire	signed	[8:0]		nst3_atan,
	input	wire	[2:0]		nst3_i,
	input wire				nst3_enable_cordic,
				
	output reg				out_nst3_bubble,
	output reg	[8:0] 	out_nst3_color,
	output reg	[9:0]		out_nst3_pixel_x,
	output reg	[9:0]		out_nst3_pixel_y,
	output reg	[8:0]		out_nst3_ref_point_x,
	output reg	[8:0]		out_nst3_ref_point_y,
	output reg				out_nst3_form,
	
	output reg	signed 	[18:0]	new_nst3_v1_x,
	output reg	signed	[18:0]	new_nst3_v1_y,
	output reg	signed	[18:0]	new_nst3_v2_x,
	output reg	signed	[18:0]	new_nst3_v2_y,
	output reg	signed	[18:0]	new_nst3_v3_x,
	output reg	signed	[18:0]	new_nst3_v3_y,
	output reg	signed	[18:0]	new_nst3_v4_x,
	output reg	signed	[18:0]	new_nst3_v4_y,
	output reg	signed	[8:0]		new_nst3_z,
	output reg							out_nst3_enable_cordic
);

	//vector 1
	wire signed [18:0] next_new_nst3_v1_x, next_new_nst3_v1_y;
	wire signed [8:0]	 next_new_nst3_z;
	cordic_unit cordic_unit_v1(
		.RVx(next_new_nst3_v1_x), 
		.RVy(next_new_nst3_v1_y), 
		.new_Z(next_new_nst3_z),
		
		.Vx(nst3_v1_x), 
		.Vy(nst3_v1_y),
		.Z(nst3_z),
		.atan(nst3_atan),
		.i(nst3_i)
	);
	
	//vector 2
	wire signed [18:0] next_new_nst3_v2_x, next_new_nst3_v2_y;
	cordic_unit cordic_unit_v2(
		.RVx(next_new_nst3_v2_x), 
		.RVy(next_new_nst3_v2_y), 
		.new_Z(),
		
		.Vx(nst3_v2_x), 
		.Vy(nst3_v2_y),
		.Z(nst3_z),
		.atan(nst3_atan),
		.i(nst3_i)
	);
	
	//vector 3
	wire signed [18:0] next_new_nst3_v3_x, next_new_nst3_v3_y;
	cordic_unit cordic_unit_v3(
		.RVx(next_new_nst3_v3_x), 
		.RVy(next_new_nst3_v3_y), 
		.new_Z(),
		
		.Vx(nst3_v3_x), 
		.Vy(nst3_v3_y),
		.Z(nst3_z),
		.atan(nst3_atan),
		.i(nst3_i)
	);
	
	//vector 2
	wire signed [18:0] next_new_nst3_v4_x, next_new_nst3_v4_y;
	cordic_unit cordic_unit_v4(
		.RVx(next_new_nst3_v4_x), 
		.RVy(next_new_nst3_v4_y), 
		.new_Z(),
		
		.Vx(nst3_v4_x), 
		.Vy(nst3_v4_y),
		.Z(nst3_z),
		.atan(nst3_atan),
		.i(nst3_i)
	);
	
	
	
	always @(posedge clk) begin
		out_nst3_color   			<= nst3_color;
		out_nst3_pixel_x 			<= nst3_pixel_x;
		out_nst3_pixel_y 			<= nst3_pixel_y;
		out_nst3_ref_point_x		<= nst3_ref_point_x;
		out_nst3_ref_point_y		<= nst3_ref_point_y;
		out_nst3_form				<= nst3_form;
	
		new_nst3_v1_x 				<= (nst3_enable_cordic) ? next_new_nst3_v1_x : nst3_v1_x;
		new_nst3_v1_y 				<= (nst3_enable_cordic) ? next_new_nst3_v1_y : nst3_v1_y;
		new_nst3_v2_x 				<= (nst3_enable_cordic) ? next_new_nst3_v2_x : nst3_v2_x;
		new_nst3_v2_y 				<= (nst3_enable_cordic) ? next_new_nst3_v2_y : nst3_v2_y;
		new_nst3_v3_x 				<= (nst3_enable_cordic) ? next_new_nst3_v3_x : nst3_v3_x;
		new_nst3_v3_y 				<= (nst3_enable_cordic) ? next_new_nst3_v3_y : nst3_v3_y;
		new_nst3_v4_x 				<= (nst3_enable_cordic) ? next_new_nst3_v4_x : nst3_v4_x;
		new_nst3_v4_y 				<= (nst3_enable_cordic) ? next_new_nst3_v4_y : nst3_v4_y;
		new_nst3_z 					<= (nst3_enable_cordic) ? next_new_nst3_z : nst3_z;
		
		out_nst3_enable_cordic	<= nst3_enable_cordic;
	end
	
	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_nst3_bubble <= 1'b0;	
		end
		else begin
			out_nst3_bubble <= nst3_bubble;
		end
	end
	
endmodule