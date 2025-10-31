module cordic_prescale(sV, V);
	input signed [10:0] V;
	output signed [18:0] sV;
	
	wire signed [18:0] pf_V, pf_sV;
	assign pf_V = V << 8;
	assign sV = ((pf_V>>>1) + (pf_V>>>4)) + (((pf_V>>>5) + (pf_V>>>7)) + (pf_V>>>8));
endmodule
