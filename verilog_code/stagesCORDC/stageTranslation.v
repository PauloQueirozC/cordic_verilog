module stageTranslation(
		input wire clk,
		input wire reset,
		
		input wire bubble,
		input wire [8:0] color,
		input wire [9:0] pixel_x,
		input wire [9:0] pixel_y,
		input wire [8:0] ref_pixel_x,
		input wire [8:0] ref_pixel_y,
		input wire 		  form,
		
		input wire signed 	[18:0]	cordic_v1_x,
		input wire signed 	[18:0]	cordic_v1_y,
		input wire signed 	[18:0]	cordic_v2_x,
		input wire signed 	[18:0]	cordic_v2_y,
		input wire signed 	[18:0]	cordic_v3_x,
		input wire signed 	[18:0]	cordic_v3_y,
		input wire signed 	[18:0]	cordic_v4_x,
		input wire signed 	[18:0]	cordic_v4_y,
		
		output reg [9:0] trans_v1_x,
		output reg [9:0] trans_v1_y,
		output reg [9:0] trans_v2_x,
		output reg [9:0] trans_v2_y,
		output reg [9:0] trans_v3_x,
		output reg [9:0] trans_v3_y,
		output reg [9:0] trans_v4_x,
		output reg [9:0] trans_v4_y,
		
		output reg	 	  	out_form,
		output reg [8:0]	out_color,
		output reg [9:0] 	out_pixel_x,
		output reg [9:0] 	out_pixel_y,
		output reg		 	out_bubble
	);
		
	wire signed [10:0]	round_v1_x, round_v1_y,
								round_v2_x, round_v2_y,
								round_v3_x, round_v3_y,
								round_v4_x, round_v4_y;
								
	assign round_v1_x = cordic_v1_x[18:8] + cordic_v1_x[7];
	assign round_v1_y = cordic_v1_y[18:8] + cordic_v1_y[7];
	assign round_v2_x = cordic_v2_x[18:8] + cordic_v2_x[7];
	assign round_v2_y = cordic_v2_y[18:8] + cordic_v2_y[7];
	assign round_v3_x = cordic_v3_x[18:8] + cordic_v3_x[7];
	assign round_v3_y = cordic_v3_y[18:8] + cordic_v3_y[7];
	assign round_v4_x = cordic_v4_x[18:8] + cordic_v4_x[7];
	assign round_v4_y = cordic_v4_y[18:8] + cordic_v4_y[7]; 
	
	
	wire signed [10:0]   temp_sum_v1_x, temp_sum_v1_y,
								temp_sum_v2_x, temp_sum_v2_y,
								temp_sum_v3_x, temp_sum_v3_y,
								temp_sum_v4_x, temp_sum_v4_y;
								
	assign temp_sum_v1_x = round_v1_x + $signed({2'd0, ref_pixel_x});
	assign temp_sum_v1_y = round_v1_y + $signed({2'd0, ref_pixel_y});
	assign temp_sum_v2_x = round_v2_x + $signed({2'd0, ref_pixel_x});
	assign temp_sum_v2_y = round_v2_y + $signed({2'd0, ref_pixel_y});
	assign temp_sum_v3_x = round_v3_x + $signed({2'd0, ref_pixel_x});
	assign temp_sum_v3_y = round_v3_y + $signed({2'd0, ref_pixel_y});
	assign temp_sum_v4_x = round_v4_x + $signed({2'd0, ref_pixel_x});
	assign temp_sum_v4_y = round_v4_y + $signed({2'd0, ref_pixel_y});

	wire [9:0]           new_trans_v1_x, new_trans_v1_y,
								new_trans_v2_x, new_trans_v2_y,
								new_trans_v3_x, new_trans_v3_y,
								new_trans_v4_x, new_trans_v4_y;

	wire have_poli = |(cordic_v1_x | cordic_v1_y); 
								
	assign new_trans_v1_x = (have_poli) ? temp_sum_v1_x[9:0] : ((form == 1'b0) ? 10'd700 : 10'd720);
	assign new_trans_v1_y = (have_poli) ? temp_sum_v1_y[9:0] : 10'd500;
	assign new_trans_v2_x = (have_poli) ? temp_sum_v2_x[9:0] : 10'd700;
	assign new_trans_v2_y = (have_poli) ? temp_sum_v2_y[9:0] : 10'd510;
	assign new_trans_v3_x = (have_poli) ? temp_sum_v3_x[9:0] : 10'd740;
	assign new_trans_v3_y = (have_poli) ? temp_sum_v3_y[9:0] : 10'd510;
	assign new_trans_v4_x = (form == 1'b0) ? ((have_poli) ? temp_sum_v4_x[9:0] : 10'd740) : 10'd0;
	assign new_trans_v4_y = (form == 1'b0) ? ((have_poli) ? temp_sum_v4_y[9:0] : 10'd500) : 10'd0;
	
	always @(posedge clk) begin
		out_color   		<= color;
		out_pixel_x 		<= pixel_x;
		out_pixel_y 		<= pixel_y;
		out_form				<= form;
	
		trans_v1_x 	<= new_trans_v1_x;
		trans_v1_y 	<= new_trans_v1_y;
		trans_v2_x 	<= new_trans_v2_x;
		trans_v2_y 	<= new_trans_v2_y;
		trans_v3_x 	<= new_trans_v3_x;
		trans_v3_y 	<= new_trans_v3_y;
		trans_v4_x 	<= new_trans_v4_x;
		trans_v4_y 	<= new_trans_v4_y;
	end
	
	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			out_bubble <= 1'b0;	
		end
		else begin
			out_bubble <= bubble;
		end
	end
endmodule

