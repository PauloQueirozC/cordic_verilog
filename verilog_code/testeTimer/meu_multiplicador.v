module meu_multiplicador(
    input wire         clk,
    input wire [9:0]   a_in,  // Vem do a_reg
    input wire [8:0]   b_in,  // Vem do b_reg
    output reg [18:0]  p_out  // 3. Registrador de Destino (O ponto "To" da análise)
);

    wire [18:0] p_next;
    
    // --- ESTA É A LÓGICA QUE VAMOS MEDIR ---
    // É o caminho combinacional entre a_in/b_in e p_next
    assign p_next = a_in * b_in;
    // -------------------------------------

    // O registrador de destino captura o resultado
    always @(posedge clk) begin
        p_out <= p_next;
    end

endmodule