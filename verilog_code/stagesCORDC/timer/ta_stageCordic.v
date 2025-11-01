// Defina ESTE módulo como o Top-Level
module ta_stageCordic (
    input  wire         clk,
    input  wire         reset,

    // --- Entradas do Chip (Reduzidas) ---
    // Removemos os 152 pinos de v_in
    input  wire [8:0]   z_in,
    input  wire [8:0]   atan_in,
    input  wire [2:0]   i_in,
    input  wire         enable_in,

    // --- Saídas (Mantidas para evitar poda) ---
    output wire [18:0]  v1_x_out,
    output wire [18:0]  v1_y_out,
    output wire [18:0]  v2_x_out,
    output wire [18:0]  v2_y_out,
    output wire [18:0]  v3_x_out,
    output wire [18:0]  v3_y_out,
    output wire [18:0]  v4_x_out,
    output wire [18:0]  v4_y_out,
    output wire [8:0]   z_out,
    output wire         enable_cordic_out
);

    // =============================================================
    // 1. REGISTRADORES DE ORIGEM (O "From" da análise)
    // =============================================================
    reg signed [18:0] nst3_v1_x_reg, nst3_v1_y_reg;
    reg signed [18:0] nst3_v2_x_reg, nst3_v2_y_reg;
    reg signed [18:0] nst3_v3_x_reg, nst3_v3_y_reg;
    reg signed [18:0] nst3_v4_x_reg, nst3_v4_y_reg;
    reg signed [8:0]  nst3_z_reg;
    reg signed [8:0]  nst3_atan_reg;
    reg [2:0]         nst3_i_reg;
    reg               nst3_enable_cordic_reg;
    
    // Registradores para as outras entradas (pass-through)
    reg         nst3_bubble_reg;
    reg [8:0]   nst3_color_reg;
    reg [9:0]   nst3_pixel_x_reg;
    reg [9:0]   nst3_pixel_y_reg;
    reg [8:0]   nst3_ref_point_x_reg;
    reg [8:0]   nst3_ref_point_y_reg;
    reg         nst3_form_reg;


    always @(posedge clk) begin
        // Conecta as entradas do chip aos regs de origem
        nst3_z_reg      <= z_in;
        nst3_atan_reg   <= atan_in;
        nst3_i_reg      <= i_in;
        nst3_enable_cordic_reg <= enable_in;
        
        // --- CORREÇÃO ---
        // Amarramos os regs 'v' a constantes.
        // O Quartus ainda construirá a lógica porque 
        // as *saídas* dependem desses regs.
        nst3_v1_x_reg   <= 19'd100; // Qualquer valor constante
        nst3_v1_y_reg   <= 19'd101;
        nst3_v2_x_reg   <= 19'd102;
        nst3_v2_y_reg   <= 19'd103;
        nst3_v3_x_reg   <= 19'd104;
        nst3_v3_y_reg   <= 19'd105;
        nst3_v4_x_reg   <= 19'd106;
        nst3_v4_y_reg   <= 19'd107;
        
        // O resto pode ficar zerado
        nst3_bubble_reg        <= 1'b0;
        nst3_color_reg         <= 9'd0;
        // ... (etc.)
    end

    // =============================================================
    // 2. INSTÂNCIA DO MÓDULO ALVO
    // =============================================================
    stageCordic inst_cordic (
        .clk(clk),
        .reset(reset),
        
        // Conectado aos nossos registradores de origem
        .nst3_v1_x(nst3_v1_x_reg),
        .nst3_v1_y(nst3_v1_y_reg),
        .nst3_v2_x(nst3_v2_x_reg),
        .nst3_v2_y(nst3_v2_y_reg),
        .nst3_v3_x(nst3_v3_x_reg),
        .nst3_v3_y(nst3_v3_y_reg),
        .nst3_v4_x(nst3_v4_x_reg),
        .nst3_v4_y(nst3_v4_y_reg),
        .nst3_z(nst3_z_reg),
        .nst3_atan(nst3_atan_reg), // <- Verifique se o nome da porta está certo
        .nst3_i(nst3_i_reg),
        .nst3_enable_cordic(nst3_enable_cordic_reg),
        
        .nst3_bubble(nst3_bubble_reg),
        .nst3_color(nst3_color_reg),
        .nst3_pixel_x(nst3_pixel_x_reg),
        .nst3_pixel_y(nst3_pixel_y_reg),
        .nst3_ref_point_x(nst3_ref_point_x_reg),
        .nst3_ref_point_y(nst3_ref_point_y_reg),
        .nst3_form(nst3_form_reg),

        // --- Saídas (Mantidas para evitar poda) ---
        .new_nst3_v1_x(v1_x_out),
        .new_nst3_v1_y(v1_y_out),
        .new_nst3_v2_x(v2_x_out),
        .new_nst3_v2_y(v2_y_out),
        .new_nst3_v3_x(v3_x_out),
        .new_nst3_v3_y(v3_y_out),
        .new_nst3_v4_x(v4_x_out),
        .new_nst3_v4_y(v4_y_out),
        .new_nst3_z(z_out),
        .out_nst3_enable_cordic(enable_cordic_out),
        
        .out_nst3_bubble(),
        .out_nst3_color(),
        .out_nst3_pixel_x(),
        .out_nst3_pixel_y(),
        .out_nst3_ref_point_x(),
        .out_nst3_ref_point_y(),
        .out_nst3_form()
    );

endmodule