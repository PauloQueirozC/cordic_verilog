module stagePreRotation(
		input wire clk,
		input wire reset,
		
		input wire					nst2_bubble,
		input wire [8:0] 			nst2_color,
		input wire [9:0] 			nst2_pixel_x,
		input wire [9:0] 			nst2_pixel_y,
		input wire [8:0]			nst2_ref_point_x,
		input wire [8:0]			nst2_ref_point_y,
		input wire					nst2_form,
		input wire signed [8:0]		nst2_angle,
		input	wire	nst2_enable_cordic,
		input wire signed [18:0]	cord_pos,
		input wire signed [18:0]	cord_neg,
		
		output reg			out_nst2_bubble,
		output reg	[8:0]	out_nst2_color,
		output reg	[9:0]	out_nst2_pixel_x,
		output reg	[9:0]	out_nst2_pixel_y,
		output reg	[8:0]	out_nst2_ref_point_x,
		output reg	[8:0]	out_nst2_ref_point_y,
		output reg			out_nst2_form,
		
		output reg signed [18:0] nst2_v1_x,
		output reg signed [18:0] nst2_v1_y,
		output reg signed [18:0] nst2_v2_x,
		output reg signed [18:0] nst2_v2_y,
		output reg signed [18:0] nst2_v3_x,
		output reg signed [18:0] nst2_v3_y,
		output reg signed [18:0] nst2_v4_x,
		output reg signed [18:0] nst2_v4_y,
		output reg signed [8:0]  nst2_z,
		output reg				 out_nst2_enable_cordic
	);
	
	reg signed [18:0] 	next_nst2_v1_x, next_nst2_v1_y, 
						next_nst2_v2_x, next_nst2_v2_y, 
						next_nst2_v3_x, next_nst2_v3_y, 
						next_nst2_v4_x, next_nst2_v4_y;
						
	reg signed [8:0] 	next_nst2_z;
	
	always @(*) begin
		case (nst2_angle[8:7])
			2'b01: begin
				next_nst2_v1_x	= (nst2_form == 1'b0) ? cord_pos : 19'd0;
				next_nst2_v1_y	= cord_neg;
				
				next_nst2_v2_x	= cord_pos;
				next_nst2_v2_y	= cord_pos;
				
				next_nst2_v3_x	= cord_neg;
				next_nst2_v3_y	= cord_pos;
				
				next_nst2_v4_x	= cord_neg;
				next_nst2_v4_y	= cord_neg;
//				next_nst2_v4_x	= (nst2_form == 1'b0) ? cord_neg  : 19'd0;
//				next_nst2_v4_y	= (nst2_form == 1'b0) ? cord_neg  : 19'd0;
				
				next_nst2_z =  nst2_angle - 9'b010000000;
			end
			2'b11: begin
				next_nst2_v1_x	= (nst2_form == 1'b0) ? cord_neg : 19'd0;
				next_nst2_v1_y	= cord_pos;
				
				next_nst2_v2_x	= cord_neg;
				next_nst2_v2_y	= cord_neg;
				
				next_nst2_v3_x	= cord_pos;
				next_nst2_v3_y	= cord_neg;
				
				next_nst2_v4_x	= cord_pos;
				next_nst2_v4_y	= cord_pos;
//				next_nst2_v4_x	= (nst2_form == 1'b0) ? cord_pos  : 19'd0;
//				next_nst2_v4_y	= (nst2_form == 1'b0) ? cord_pos  : 19'd0;
				
				next_nst2_z	=  nst2_angle + 9'b010000000;
			end
			2'b10: begin
				next_nst2_v1_x	= (nst2_form == 1'b0) ? cord_pos : 19'd0;
				next_nst2_v1_y	= cord_pos;
				
				next_nst2_v2_x	= cord_pos;
				next_nst2_v2_y	= cord_neg;
				
				next_nst2_v3_x	= cord_neg;
				next_nst2_v3_y	= cord_neg;
				
				next_nst2_v4_x	= cord_neg;
				next_nst2_v4_y	= cord_pos;
//				next_nst2_v4_x	= (nst2_form == 1'b0) ? cord_neg  : 19'd0;
//				next_nst2_v4_y	= (nst2_form == 1'b0) ? cord_pos  : 19'd0;
				
				next_nst2_z =  nst2_angle - 9'b100000000;
			end
			default: begin
				next_nst2_v1_x	= (nst2_form == 1'b0) ? cord_neg : 19'd0;
				next_nst2_v1_y	= cord_neg;
				
				next_nst2_v2_x	= cord_neg;
				next_nst2_v2_y	= cord_pos;
				
				next_nst2_v3_x	= cord_pos;
				next_nst2_v3_y	= cord_pos;
				
				next_nst2_v4_x	= cord_pos;
				next_nst2_v4_y	= cord_neg;
//				next_nst2_v4_x	= (nst2_form == 1'b0) ? cord_pos  : 19'd0;
//				next_nst2_v4_y	= (nst2_form == 1'b0) ? cord_neg  : 19'd0;
				
				next_nst2_z =  nst2_angle;
			end
		endcase
	end
	
	always @(posedge clk) begin
		out_nst2_color   			<= nst2_color;
		out_nst2_pixel_x 			<= nst2_pixel_x;
		out_nst2_pixel_y 			<= nst2_pixel_y;
		out_nst2_ref_point_x		<= nst2_ref_point_x;
		out_nst2_ref_point_y		<= nst2_ref_point_y;
		out_nst2_form				<= nst2_form;
		out_nst2_enable_cordic	<= nst2_enable_cordic;
	
		nst2_v1_x 				<= next_nst2_v1_x;
		nst2_v1_y 				<= next_nst2_v1_y;
		nst2_v2_x 				<= next_nst2_v2_x;
		nst2_v2_y 				<= next_nst2_v2_y;
		nst2_v3_x 				<= next_nst2_v3_x;
		nst2_v3_y 				<= next_nst2_v3_y;
		nst2_v4_x 				<= next_nst2_v4_x;
		nst2_v4_y 				<= next_nst2_v4_y;
		nst2_z 					<= next_nst2_z;
	end
	
	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_nst2_bubble <= 1'b0;	
		end
		else begin
			out_nst2_bubble <= nst2_bubble;
		end
	end
endmodule