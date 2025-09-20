module teste_cordic_prop(Dig5, Dig4, Dig3, Dig2, Dig1, Dig0, Done, Start, Reset, clk_50, angle);
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

module signed_to_7seg (
    // Entradas
    input wire signed [16:0] data_in,

    // Saídas
    output wire [6:0] Dig4,  // Dígito da dezena de milhar (mais à esquerda)
    output wire [6:0] Dig3,  // Dígito do milhar
    output wire [6:0] Dig2,  // Dígito da centena
    output wire [6:0] Dig1,  // Dígito da dezena
    output wire [6:0] Dig0,  // Dígito da unidade (mais à direita)
    output wire       Sig    // Sinal: 1 para positivo/zero, 0 para negativo
);

    // --- Lógica Interna ---

    // 1. Determinar o sinal e o valor absoluto (magnitude)
    wire is_negative = data_in[16]; // O bit 16 é o bit de sinal
    wire [16:0] abs_value;

    assign Sig = ~is_negative; // Sig é 0 se for negativo, 1 se for positivo/zero

    // Calcula o valor absoluto: se for negativo, faz o complemento de dois
    assign abs_value = is_negative ? (~data_in + 1) : data_in;


    // 2. Extrair os 5 dígitos (conversão de Binário para BCD)
    // O sintetizador converte estas operações de divisão/módulo em lógica
    // combinacional eficiente, não em divisores lentos.
    wire [3:0] digit0, digit1, digit2, digit3, digit4;
    wire [16:0] temp1, temp2, temp3, temp4;

    assign digit0 = abs_value % 10;
    assign temp1  = abs_value / 10;
    assign digit1 = temp1 % 10;
    assign temp2  = temp1 / 10;
    assign digit2 = temp2 % 10;
    assign temp3  = temp2 / 10;
    assign digit3 = temp3 % 10;
    assign temp4  = temp3 / 10;
    assign digit4 = temp4 % 10;


    // 3. Instanciar os decodificadores para cada dígito
    // Cada instância do 'bcd_to_7seg' traduz um dígito para acender um display.
    bcd_to_7seg decoder0 (
        .bcd_in(digit0),
        .seg_out(Dig0)
    );

    bcd_to_7seg decoder1 (
        .bcd_in(digit1),
        .seg_out(Dig1)
    );

    bcd_to_7seg decoder2 (
        .bcd_in(digit2),
        .seg_out(Dig2)
    );

    bcd_to_7seg decoder3 (
        .bcd_in(digit3),
        .seg_out(Dig3)
    );

    bcd_to_7seg decoder4 (
        .bcd_in(digit4),
        .seg_out(Dig4)
    );

endmodule

module bcd_to_7seg (
    input  wire [3:0] bcd_in,    // Entrada BCD (0-9)
    output reg  [6:0] seg_out    // Saída para os 7 segmentos {g,f,e,d,c,b,a}
);

    // Lógica combinacional para decodificar a entrada
    always @(*) begin
        case (bcd_in)
            4'd0:    seg_out = ~7'b0111111; // 0
            4'd1:    seg_out = ~7'b0000110; // 1
            4'd2:    seg_out = ~7'b1011011; // 2
            4'd3:    seg_out = ~7'b1001111; // 3
            4'd4:    seg_out = ~7'b1100110; // 4
            4'd5:    seg_out = ~7'b1101101; // 5
            4'd6:    seg_out = ~7'b1111101; // 6
            4'd7:    seg_out = ~7'b0000111; // 7
            4'd8:    seg_out = ~7'b1111111; // 8
            4'd9:    seg_out = ~7'b1101111; // 9
            default: seg_out = ~7'b0000000; // Display apagado para entradas inválidas
        endcase
    end

endmodule
	