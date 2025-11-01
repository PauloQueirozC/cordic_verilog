module stageCordicPrescale(
		input	wire			clk,
		input	wire 			reset,
		
		input	wire			nst1_bubble,
		input	wire	[8:0] nst1_color,
		input	wire	[9:0] nst1_pixel_x,
		input	wire	[9:0] nst1_pixel_y,
		input	wire	[8:0]	nst1_ref_point_x,
		input	wire	[8:0]	nst1_ref_point_y,
		input	wire			nst1_form,
		input	wire 	[6:0]	size,
		input wire signed [8:0] nst1_angle,
		
		output reg	signed	[18:0] cord_pos,
		output reg	signed	[18:0] cord_neg,
		output reg			out_nst1_form,
		output reg	[8:0]	out_nst1_color,
		output reg	[9:0]	out_nst1_pixel_x,
		output reg	[9:0]	out_nst1_pixel_y,
		output reg			out_nst1_bubble,
		output reg	[8:0]	out_nst1_ref_point_x,
		output reg	[8:0]	out_nst1_ref_point_y,
		output reg	signed [8:0] out_nst1_angle
	);
	
	wire signed [18:0] next_cord_pos, next_cord_neg, cord_base;

	assign cord_base 	= {4'b0, size, 8'b0};
	assign next_cord_pos   = (cord_base * 9'sd155) >>> 8;
	assign next_cord_neg	= - next_cord_pos;
	
	always @(posedge clk) begin
		out_nst1_color   			<= nst1_color;
		out_nst1_pixel_x 			<= nst1_pixel_x;
		out_nst1_pixel_y 			<= nst1_pixel_y;
		out_nst1_form				<= nst1_form;
		out_nst1_ref_point_x		<= nst1_ref_point_x;
		out_nst1_ref_point_y		<= nst1_ref_point_y;
		out_nst1_angle				<= nst1_angle;
	
		cord_pos <= next_cord_pos;
		cord_neg <= next_cord_neg;
	end
	
	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_nst1_bubble <= 1'b0;	
		end
		else begin
			out_nst1_bubble <= nst1_bubble;
		end
	end
endmodule