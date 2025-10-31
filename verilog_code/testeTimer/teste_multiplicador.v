// Este é o seu módulo Top-Level
module teste_multiplicador(
    input wire clk,
    input wire [9:0] a_porta_in,  // 10 bits
    input wire [8:0] b_porta_in,  // 9 bits
    output wire [18:0] p_porta_out
);

    // 1. Registradores de Origem (O ponto "From" da análise)
    reg [9:0] a_reg;
    reg [8:0] b_reg;

    always @(posedge clk) begin
        a_reg <= a_porta_in;
        b_reg <= b_porta_in;
    end

    // 2. Instância do módulo que contém a lógica que queremos medir
    meu_multiplicador inst_mult (
        .clk(clk),
        .a_in(a_reg),          // Dado sai do a_reg
        .b_in(b_reg),          // Dado sai do b_reg
        .p_out(p_porta_out)    // Dado vai para o registrador p_out
    );

endmodule