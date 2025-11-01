// Defina ESTE módulo como o Top-Level
module ta_stagePreRotation(
    input  wire         clk,
    input  wire         reset,

    // --- Entradas do Chip (completas) ---
    input  wire         nst2_bubble_in,
    input  wire [8:0]   nst2_color_in,
    input  wire [9:0]   nst2_pixel_x_in,
    input  wire [9:0]   nst2_pixel_y_in,
    input  wire [8:0]   nst2_ref_point_x_in,
    input  wire [8:0]   nst2_ref_point_y_in,
    input  wire         nst2_form_in,
    input  wire signed  [8:0]   nst2_angle_in,
    input  wire signed  [18:0]  cord_pos_in,
    input  wire signed  [18:0]  cord_neg_in,

    // --- Saída do Chip (Corrigida) ---
    // Conectamos apenas a saída do pior caminho para 
    // forçar o compilador a manter toda a lógica.
    output wire         enable_cordic_out
);

    // =============================================================
    // 1. REGISTRADORES DE ORIGEM (O "From" da análise)
    // =============================================================
    reg         nst2_bubble_reg;
    reg [8:0]   nst2_color_reg;
    reg [9:0]   nst2_pixel_x_reg;
    reg [9:0]   nst2_pixel_y_reg;
    reg [8:0]   nst2_ref_point_x_reg;
    reg [8:0]   nst2_ref_point_y_reg;
    reg         nst2_form_reg;
    reg signed  [8:0]   nst2_angle_reg;
    reg signed  [18:0]  cord_pos_reg;
    reg signed  [18:0]  cord_neg_reg;

    always @(posedge clk) begin
        nst2_bubble_reg      <= nst2_bubble_in;
        nst2_color_reg       <= nst2_color_in;
        nst2_pixel_x_reg     <= nst2_pixel_x_in;
        nst2_pixel_y_reg     <= nst2_pixel_y_in;
        nst2_ref_point_x_reg <= nst2_ref_point_x_in;
        nst2_ref_point_y_reg <= nst2_ref_point_y_in;
        nst2_form_reg        <= nst2_form_in;
        nst2_angle_reg       <= nst2_angle_in;
        cord_pos_reg         <= cord_pos_in;
        cord_neg_reg         <= cord_neg_in;
    end

    // =============================================================
    // 2. INSTÂNCIA DO MÓDULO ALVO
    // =============================================================
    stagePreRotation inst_prerot (
        .clk(clk),
        .reset(reset),
        
        // Conectado aos nossos registradores de origem
        .nst2_bubble(nst2_bubble_reg),
        .nst2_color(nst2_color_reg),
        .nst2_pixel_x(nst2_pixel_x_reg),
        .nst2_pixel_y(nst2_pixel_y_reg),
        .nst2_ref_point_x(nst2_ref_point_x_reg),
        .nst2_ref_point_y(nst2_ref_point_y_reg),
        .nst2_form(nst2_form_reg),
        .nst2_angle(nst2_angle_reg),
        .cord_pos(cord_pos_reg),
        .cord_neg(cord_neg_reg),
        
        // --- Saídas ---
        // Conectamos APENAS a saída do pior caso ao pino do chip
        .nst2_enable_cordic(enable_cordic_out), 
        
        // O resto pode ficar flutuando (sintaxe .porta() vazia).
        // O Quartus manterá tudo, pois o 'enable_cordic'
        // depende do 'next_nst2_z', que depende do 'case',
        // que depende de 'cord_pos', 'cord_neg', etc.
        .out_nst2_bubble(),
        .out_nst2_color(),
        .out_nst2_pixel_x(),
        .out_nst2_pixel_y(),
        .out_nst2_ref_point_x(),
        .out_nst2_ref_point_y(),
        .out_nst2_form(),
        .nst2_v1_x(),
        .nst2_v1_y(),
        .nst2_v2_x(),
        .nst2_v2_y(),
        .nst2_v3_x(),
        .nst2_v3_y(),
        .nst2_v4_x(),
        .nst2_v4_y(),
        .nst2_z()
    );

endmodule