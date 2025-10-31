// Este é o seu módulo Top-Level
module ta_stageCordicPrescale(
    input wire clk,
    input wire reset,

    // Entradas do chip (que alimentarão os regs de origem)
    input wire        nst1_bubble,
    input wire [8:0]  nst1_color,
    input wire [9:0]  nst1_pixel_x,
    input wire [9:0]  nst1_pixel_y,
    input wire [8:0]  nst1_ref_point_x,
    input wire [8:0]  nst1_ref_point_y,
    input wire        nst1_form,
    input wire [6:0]  size,
    
    // Saídas do chip
    output wire [18:0] cord_pos,
    output wire [18:0] cord_neg,
    output wire        out_nst1_bubble
    // ... (adicione as outras saídas se precisar)
);

    // 1. Registradores de Origem (O "From" da análise)
    reg        nst1_bubble_reg;
    reg [8:0]  nst1_color_reg;
    reg [9:0]  nst1_pixel_x_reg;
    reg [9:0]  nst1_pixel_y_reg;
    reg [8:0]  nst1_ref_point_x_reg;
    reg [8:0]  nst1_ref_point_y_reg;
    reg        nst1_form_reg;
    reg [6:0]  size_reg; // Este é o registrador mais importante para a lógica

    always @(posedge clk) begin
        nst1_bubble_reg      <= nst1_bubble;
        nst1_color_reg       <= nst1_color;
        nst1_pixel_x_reg     <= nst1_pixel_x;
        nst1_pixel_y_reg     <= nst1_pixel_y;
        nst1_ref_point_x_reg <= nst1_ref_point_x;
        nst1_ref_point_y_reg <= nst1_ref_point_y;
        nst1_form_reg        <= nst1_form;
        size_reg             <= size;
    end

    // 2. Instância do módulo que queremos medir
    stageCordicPrescale inst_prescale (
        .clk(clk),
        .reset(reset),
        
        // Alimentado pelos nossos registradores de origem
        .nst1_bubble(nst1_bubble_reg),
        .nst1_color(nst1_color_reg),
        .nst1_pixel_x(nst1_pixel_x_reg),
        .nst1_pixel_y(nst1_pixel_y_reg),
        .nst1_ref_point_x(nst1_ref_point_x_reg),
        .nst1_ref_point_y(nst1_ref_point_y_reg),
        .nst1_form(nst1_form_reg),
        .size(size_reg), // Dado sai do size_reg
        
        // Conectado aos registradores de destino (dentro do 'inst_prescale')
        .cord_pos(cord_pos), // Dado vai para o reg cord_pos
        .cord_neg(cord_neg), // Dado vai para o reg cord_neg
        .out_nst1_bubble(out_nst1_bubble)
        // ... (conecte as outras saídas)
    );

endmodule