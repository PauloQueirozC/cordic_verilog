
module init_cordic(
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
	
	output reg signed [18:0] v1_x,
	output reg signed [18:0] v1_y,
	output reg signed [18:0] v2_x,
	output reg signed [18:0] v2_y,
	output reg signed [18:0] v3_x,
	output reg signed [18:0] v3_y,
	output reg signed [18:0] v4_x,
	output reg signed [18:0] v4_y,
	output reg signed [8:0]  angle_cordic,
	output reg 					 enable_cordic,
	
	output reg		  out_form,
	output reg [8:0] out_st2_color,
   output reg [9:0] out_st2_pixel_x,
   output reg [9:0] out_st2_pixel_y,
   output reg 		  out_st2_bubble,
	output reg [8:0] out_ref_point_x,
	output reg [8:0] out_ref_point_y
);
	// Pre escalonamento das cordenadas do poligono centrado na origem
	wire signed [18:0] cord_0, cord_pos, cord_neg, cord_base;
	
	assign cord_0   	= 18'b0;
	assign cord_base 	= {4'b0, size};
	assign cord_pos   = ((cord_base>>>1) + (cord_base>>>4)) + (((cord_base>>>5) + (cord_base>>>7)) + (cord_base>>>8));
	assign cord_neg	= - cord_pos;
	
	// Pre rotaçao dos vetores
	reg signed [18:0] 	next_v1_x, next_v1_y, 
								next_v2_x, next_v2_y,
								next_v3_x, next_v3_y, 
								next_v4_x, next_v4_y;
	reg signed [8:0] 	next_angle_cordic;
	
	always @(*) begin
		case (angle[8:7])
			2'b01: begin
				next_v1_x	= (form == 1'b0) ? cord_pos : cord_0;
				next_v1_y	= cord_neg;
				
				next_v2_x	= cord_pos;
				next_v2_y	= cord_pos;
				
				next_v3_x	= cord_neg;
				next_v3_y	= cord_pos;
				
				next_v4_x	= (form == 1'b0) ? cord_neg  : 18'd0;
				next_v4_y	= (form == 1'b0) ? cord_neg  : 18'd0;
				
				next_angle_cordic =  angle - 9'b010000000;
			end
			2'b10: begin
				next_v1_x	= (form == 1'b0) ? cord_neg : cord_0;
				next_v1_y	= cord_pos;
				
				next_v2_x	= cord_neg;
				next_v2_y	= cord_neg;
				
				next_v3_x	= cord_pos;
				next_v3_y	= cord_neg;
				
				next_v4_x	= (form == 1'b0) ? cord_pos  : 18'd0;
				next_v4_y	= (form == 1'b0) ? cord_pos  : 18'd0;
				
				next_angle_cordic	=  angle + 9'b010000000;
			end
			default: begin
				next_v1_x	= (form == 1'b0) ? cord_neg : cord_0;
				next_v1_y	= cord_neg;
				
				next_v2_x	= cord_neg;
				next_v2_y	= cord_pos;
				
				next_v3_x	= cord_pos;
				next_v3_y	= cord_pos;
				
				next_v4_x	= (form == 1'b0) ? cord_pos  : 18'd0;
				next_v4_y	= (form == 1'b0) ? cord_neg  : 18'd0;
				
				next_angle_cordic =  angle;
			end
		endcase
	end
	
	// calculon do enable cordic
	wire next_enable_cordic;
	assign next_enable_cordic = next_angle_cordic != 9'b0;
	
	// Enviando os dados para proximo estagio
	always @(posedge clk) begin
		out_st2_color   	<= st2_color;
		out_st2_pixel_x 	<= st2_pixel_x;
		out_st2_pixel_y 	<= st2_pixel_y;
		out_form  			<= form;
		out_ref_point_x <= ref_point_x;
		out_ref_point_y <= ref_point_y;
	
		v1_x <= next_v1_x;
		v1_y <= next_v1_y; 
		v2_x <= next_v2_x;
		v2_y <= next_v2_y;
		v3_x <= next_v3_x;
		v3_y <= next_v3_y; 
		v4_x <= next_v4_x;
		v4_y <= next_v4_y;
		angle_cordic <= next_angle_cordic;
		enable_cordic <= next_enable_cordic;
	end

	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_st2_bubble <= 1'b0;	
		end
		else begin
			out_st2_bubble <= st2_bubble;
		end
	end
endmodule