/*module stageCordic(
	input	wire	clk,
	input wire	reset,
	
	input wire				nst3_bubble,
	input wire	[8:0] 	nst3_color,
	input wire	[9:0]		nst3_pixel_x,
	input wire	[9:0]		nst3_pixel_y,
	input wire	[8:0]		nst3_ref_point_x,
	input wire	[8:0]		nst3_ref_point_y,
	input	wire				nst3_form,
	input wire	[18:0]	nst3_v1_x,
	input wire	[18:0]	nst3_v1_y,
	input wire	[18:0]	nst3_v2_x,
	input wire	[18:0]	nst3_v2_y,
	input wire	[18:0]	nst3_v3_x,
	input wire	[18:0]	nst3_v3_y,
	input wire	[18:0]	nst3_v4_x,
	input wire	[18:0]	nst3_v4_y,
	input wire	[8:0]		nst3_z,
	input wire	[8:0]		nst3_teta0,
	input	wire	[8:0]		nst3_teta1,
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
	wire signed 
	doble_cordic doble_cordic_v1(
		.RVx(), 
		.RVy(), 
		.new_Z(),
		
		.Vx(), 
		.Vy(),
		.Z(),
		.atan0(), 
		.atan1(),
		.i()
	);
	
	
	
	always @(posedge clk) begin
		out_nst3_color   			<= nst3_color;
		out_nst3_pixel_x 			<= nst3_pixel_x;
		out_nst3_pixel_y 			<= nst3_pixel_y;
		out_nst3_ref_point_x		<= nst3_ref_point_x;
		out_nst3_ref_point_y		<= nst3_ref_point_y;
		out_nst3_form				<= nst3_form;
	
		new_nst3_v1_x 				<= next_new_nst3_v1_x;
		new_nst3_v1_y 				<= next_new_nst3_v1_y;
		new_nst3_v2_x 				<= next_new_nst3_v2_x;
		new_nst3_v2_y 				<= next_new_nst3_v2_y;
		new_nst3_v3_x 				<= next_new_nst3_v3_x;
		new_nst3_v3_y 				<= next_new_nst3_v3_y;
		new_nst3_v4_x 				<= next_new_nst3_v4_x;
		new_nst3_v4_y 				<= next_new_nst3_v4_y;
		new_nst3_z 					<= next_new_nst3_z;
		
		out_nst3_enable_cordic	<= next_out_nst3_enable_cordic;
	end
	
	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_nst3_bubble <= 1'b0;	
		end
		else begin
			out_nst3_bubble <= nst2_bubble;
		end
	end
	
endmodule*/