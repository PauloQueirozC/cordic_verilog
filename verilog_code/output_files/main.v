module main(Dig5, Dig4, Dig3, Dig2, Dig1, Dig0, Done, Start, Reset, clk_50, angle);
	output 		  [6:0] Dig5, Dig4, Dig3, Dig2, Dig1, Dig0;
	output 				  Done;
	input			 		  Start, Reset, clk_50;
	input  signed [9:0] angle;
	
	reg  			displayMode = 1'b0;
	wire signed [16:0] x_out;
	wire signed [16:0] displayNumber;
	wire 					 sig;
	
	assign Dig5 = {sig, 6'b111111};
	assign displayNumber = displayMode ? x_out : {7'b0, angle};
	
	cordic	cordic(
						.cos_z0(x_out),
						.sin_z0(),
						.done(Done),
						.z0({angle, 22'b0}),
						.start(~Start),
						.clock(clk_50),
						.reset(~Reset)
					);
					
	signed_to_7seg signed_to_7seg(
						.data_in(displayNumber),
						.Dig4(Dig4),
						.Dig3(Dig3),
						.Dig2(Dig2),
						.Dig1(Dig1),
						.Dig0(Dig0),
						.Sig(sig)
					);
		
	always @(posedge clk_50) begin
		if 	  (!Reset) 	displayMode <= 0;
		else if (!Start)	displayMode <= 1;
		else 					displayMode <= displayMode;
	end
	
	
endmodule
	