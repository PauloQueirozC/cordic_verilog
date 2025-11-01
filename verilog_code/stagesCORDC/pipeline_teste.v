/*
 * ======================================================================
 * MÓDULO TOP-LEVEL DO PIPELINE CORDIC (10 ESTÁGIOS)
 * ======================================================================
 * Estágio 1:   stageCordicPrescale
 * Estágio 2:   stagePreRotation
 * Estágios 3-10: 8x instâncias do stageCordic em cadeia (Iterações 0-7)
 * ======================================================================
 */
module pipeline_teste (
    input  wire         clk,
    input  wire         reset,

    // --- Entradas do Estágio 1 (Prescale) ---
    input  wire         nst1_bubble,
    input  wire [8:0]   nst1_color,
    input  wire [9:0]   nst1_pixel_x,
    input  wire [9:0]   nst1_pixel_y,
    input  wire [8:0]   nst1_ref_point_x,
    input  wire [8:0]   nst1_ref_point_y,
    input  wire         nst1_form,
    input  wire [6:0]   size,
    input  wire signed  [8:0]   nst1_angle,
    
    // --- Saídas Finais (do Estágio 10) ---
    output wire         out_final_bubble,
    output wire [8:0]   out_final_color,
    output wire [9:0]   out_final_pixel_x,
    output wire [9:0]   out_final_pixel_y,
    output wire [8:0]   out_final_ref_point_x,
    output wire [8:0]   out_final_ref_point_y,
    output wire         out_final_form,
    output wire signed  [10:0]  final_v1_x,
    output wire signed  [10:0]  final_v1_y,
    output wire signed  [10:0]  final_v2_x,
    output wire signed  [10:0]  final_v2_y,
    output wire signed  [10:0]  final_v3_x,
    output wire signed  [10:0]  final_v3_y,
    output wire signed  [10:0]  final_v4_x,
    output wire signed  [10:0]  final_v4_y,
    output wire signed  [8:0]   final_z,
    output wire         final_enable_cordic
);

    // =================================================================
    // Definição da Tabela (LUT) de ATAN para 8 iterações
    // (Assumindo formato Q.8 com 90 graus = 128)
    // =================================================================
    localparam signed [8:0] ATAN_0 = 9'd64; // atan(2^0)  = 45.0   graus
    localparam signed [8:0] ATAN_1 = 9'd38; // atan(2^-1) = 26.57  graus
    localparam signed [8:0] ATAN_2 = 9'd20; // atan(2^-2) = 14.04  graus
    localparam signed [8:0] ATAN_3 = 9'd10; // atan(2^-3) = 7.13   graus
    localparam signed [8:0] ATAN_4 = 9'd5;  // atan(2^-4) = 3.58   graus
    localparam signed [8:0] ATAN_5 = 9'd3;  // atan(2^-5) = 1.79   graus
    localparam signed [8:0] ATAN_6 = 9'd1;  // atan(2^-6) = 0.895  graus
    localparam signed [8:0] ATAN_7 = 9'd1;  // atan(2^-7) = 0.447  graus

    // =================================================================
    // Wires de Conexão entre Estágios
    // =================================================================

    // Wires [0] = Saída do Estágio 1 (Prescale)
    wire signed [18:0]  w_cord_pos_S1;
    wire signed [18:0]  w_cord_neg_S1;
    wire signed [8:0]   w_angle_S1;
    wire                w_enable_S1;
    wire [8:0]          w_color_S1;
    wire [9:0]          w_pixel_x_S1, w_pixel_y_S1;
    wire [8:0]          w_ref_x_S1, w_ref_y_S1;
    wire                w_bubble_S1, w_form_S1;

    // Wires [1] = Saída do Estágio 2 (PreRotation)
    wire signed [18:0]  w_v1_x_S2, w_v1_y_S2, w_v2_x_S2, w_v2_y_S2;
    wire signed [18:0]  w_v3_x_S2, w_v3_y_S2, w_v4_x_S2, w_v4_y_S2;
    wire signed [8:0]   w_z_S2;
    wire                w_enable_S2;
    wire [8:0]          w_color_S2;
    wire [9:0]          w_pixel_x_S2, w_pixel_y_S2;
    wire [8:0]          w_ref_x_S2, w_ref_y_S2;
    wire                w_bubble_S2, w_form_S2;

    // Wires [2]..[8] = Saídas dos Estágios CORDIC intermediários (Iterações 0 a 6)
    // Usamos arrays [0:7] para 8 estágios.
    wire signed [18:0]  w_v1_x [0:7], w_v1_y [0:7];
    wire signed [18:0]  w_v2_x [0:7], w_v2_y [0:7];
    wire signed [18:0]  w_v3_x [0:7], w_v3_y [0:7];
    wire signed [18:0]  w_v4_x [0:7], w_v4_y [0:7];
    wire signed [8:0]   w_z [0:7];
    wire                w_enable [0:7];
    wire [8:0]          w_color [0:7];
    wire [9:0]          w_pixel_x [0:7], w_pixel_y [0:7];
    wire [8:0]          w_ref_x [0:7], w_ref_y [0:7];
    wire                w_bubble [0:7], w_form [0:7];


    // =================================================================
    // ESTÁGIO 1: Prescale
    // =================================================================
    stageCordicPrescale inst_prescale (
        .clk(clk), .reset(reset),
        
        .nst1_bubble(nst1_bubble),
        .nst1_color(nst1_color),
        .nst1_pixel_x(nst1_pixel_x),
        .nst1_pixel_y(nst1_pixel_y),
        .nst1_ref_point_x(nst1_ref_point_x),
        .nst1_ref_point_y(nst1_ref_point_y),
        .nst1_form(nst1_form),
        .size(size),
        .nst1_angle(nst1_angle),
        
        .cord_pos(w_cord_pos_S1),
        .cord_neg(w_cord_neg_S1),
        .enabel_cordic(w_enable_S1),
        .out_nst1_angle(w_angle_S1),
        .out_nst1_bubble(w_bubble_S1),
        .out_nst1_color(w_color_S1),
        .out_nst1_pixel_x(w_pixel_x_S1),
        .out_nst1_pixel_y(w_pixel_y_S1),
        .out_nst1_ref_point_x(w_ref_x_S1),
        .out_nst1_ref_point_y(w_ref_y_S1),
        .out_nst1_form(w_form_S1)
    );

    // =================================================================
    // ESTÁGIO 2: Pre-Rotation
    // =================================================================
    stagePreRotation inst_prerotation (
        .clk(clk), .reset(reset),
        
        .nst2_angle(w_angle_S1),
        .cord_pos(w_cord_pos_S1),
        .cord_neg(w_cord_neg_S1),
        .nst2_enable_cordic(w_enable_S1),
        .nst2_bubble(w_bubble_S1),
        .nst2_color(w_color_S1),
        .nst2_pixel_x(w_pixel_x_S1),
        .nst2_pixel_y(w_pixel_y_S1),
        .nst2_ref_point_x(w_ref_x_S1),
        .nst2_ref_point_y(w_ref_y_S1),
        .nst2_form(w_form_S1),
        
        .nst2_v1_x(w_v1_x_S2), .nst2_v1_y(w_v1_y_S2),
        .nst2_v2_x(w_v2_x_S2), .nst2_v2_y(w_v2_y_S2),
        .nst2_v3_x(w_v3_x_S2), .nst2_v3_y(w_v3_y_S2),
        .nst2_v4_x(w_v4_x_S2), .nst2_v4_y(w_v4_y_S2),
        .nst2_z(w_z_S2),
        .out_nst2_enable_cordic(w_enable_S2),
        .out_nst2_bubble(w_bubble_S2),
        .out_nst2_color(w_color_S2),
        .out_nst2_pixel_x(w_pixel_x_S2),
        .out_nst2_pixel_y(w_pixel_y_S2),
        .out_nst2_ref_point_x(w_ref_x_S2),
        .out_nst2_ref_point_y(w_ref_y_S2),
        .out_nst2_form(w_form_S2)
    );

    // =================================================================
    // ESTÁGIO 3: CORDIC Iteração 0 (Primeiro da cadeia)
    // =================================================================
    stageCordic inst_cordic_0 (
        .clk(clk), .reset(reset),
        
        .nst3_v1_x(w_v1_x_S2), .nst3_v1_y(w_v1_y_S2),
        .nst3_v2_x(w_v2_x_S2), .nst3_v2_y(w_v2_y_S2),
        .nst3_v3_x(w_v3_x_S2), .nst3_v3_y(w_v3_y_S2),
        .nst3_v4_x(w_v4_x_S2), .nst3_v4_y(w_v4_y_S2),
        .nst3_z(w_z_S2),
        .nst3_enable_cordic(w_enable_S2),
        .nst3_bubble(w_bubble_S2),
        .nst3_color(w_color_S2),
        .nst3_pixel_x(w_pixel_x_S2),
        .nst3_pixel_y(w_pixel_y_S2),
        .nst3_ref_point_x(w_ref_x_S2),
        .nst3_ref_point_y(w_ref_y_S2),
        .nst3_form(w_form_S2),
        
        .nst3_atan(ATAN_0), // <--- Valor da LUT
        .nst3_i(3'd0),          // <--- Iteração 0
        
        .new_nst3_v1_x(w_v1_x[0]), .new_nst3_v1_y(w_v1_y[0]),
        .new_nst3_v2_x(w_v2_x[0]), .new_nst3_v2_y(w_v2_y[0]),
        .new_nst3_v3_x(w_v3_x[0]), .new_nst3_v3_y(w_v3_y[0]),
        .new_nst3_v4_x(w_v4_x[0]), .new_nst3_v4_y(w_v4_y[0]),
        .new_nst3_z(w_z[0]),
        .out_nst3_enable_cordic(w_enable[0]),
        .out_nst3_bubble(w_bubble[0]),
        .out_nst3_color(w_color[0]),
        .out_nst3_pixel_x(w_pixel_x[0]),
        .out_nst3_pixel_y(w_pixel_y[0]),
        .out_nst3_ref_point_x(w_ref_x[0]),
        .out_nst3_ref_point_y(w_ref_y[0]),
        .out_nst3_form(w_form[0])
    );

    // =================================================================
    // ESTÁGIOS 4-9: CORDIC Iterações 1 a 6 (usando generate)
    // =================================================================
    genvar j;
    generate
        for (j = 1; j < 7; j = j + 1) begin : cordic_iterations_1_to_6
            stageCordic inst_cordic_j (
                .clk(clk), .reset(reset),
                
                // Entradas vêm do estágio anterior (j-1)
                .nst3_v1_x(w_v1_x[j-1]), .nst3_v1_y(w_v1_y[j-1]),
                .nst3_v2_x(w_v2_x[j-1]), .nst3_v2_y(w_v2_y[j-1]),
                .nst3_v3_x(w_v3_x[j-1]), .nst3_v3_y(w_v3_y[j-1]),
                .nst3_v4_x(w_v4_x[j-1]), .nst3_v4_y(w_v4_y[j-1]),
                .nst3_z(w_z[j-1]),
                .nst3_enable_cordic(w_enable[j-1]),
                .nst3_bubble(w_bubble[j-1]),
                .nst3_color(w_color[j-1]),
                .nst3_pixel_x(w_pixel_x[j-1]),
                .nst3_pixel_y(w_pixel_y[j-1]),
                .nst3_ref_point_x(w_ref_x[j-1]),
                .nst3_ref_point_y(w_ref_y[j-1]),
                .nst3_form(w_form[j-1]),
                
                .nst3_atan((j==1) ? ATAN_1 : (j==2) ? ATAN_2 : (j==3) ? ATAN_3 : (j==4) ? ATAN_4 : (j==5) ? ATAN_5 : ATAN_6), // <--- Valor da LUT
                .nst3_i(j[2:0]),         // <--- Iteração j
                
                // Saídas vão para o próximo estágio (j)
                .new_nst3_v1_x(w_v1_x[j]), .new_nst3_v1_y(w_v1_y[j]),
                .new_nst3_v2_x(w_v2_x[j]), .new_nst3_v2_y(w_v2_y[j]),
                .new_nst3_v3_x(w_v3_x[j]), .new_nst3_v3_y(w_v3_y[j]),
                .new_nst3_v4_x(w_v4_x[j]), .new_nst3_v4_y(w_v4_y[j]),
                .new_nst3_z(w_z[j]),
                .out_nst3_enable_cordic(w_enable[j]),
                .out_nst3_bubble(w_bubble[j]),
                .out_nst3_color(w_color[j]),
                .out_nst3_pixel_x(w_pixel_x[j]),
                .out_nst3_pixel_y(w_pixel_y[j]),
                .out_nst3_ref_point_x(w_ref_x[j]),
                .out_nst3_ref_point_y(w_ref_y[j]),
                .out_nst3_form(w_form[j])
            );
        end
    endgenerate
    
    // =================================================================
    // ESTÁGIO 10: CORDIC Iteração 7 (Último estágio)
    // =================================================================
	 wire signed [18:0] 	temp_final_v1_x, temp_final_v1_y,
								temp_final_v2_x, temp_final_v2_y,
								temp_final_v3_x, temp_final_v3_y,
								temp_final_v4_x, temp_final_v4_y;
								
	 assign final_v1_x = temp_final_v1_x[18:8] + temp_final_v1_x[7];
	 assign final_v1_y = temp_final_v1_y[18:8] + temp_final_v1_y[7];
	 assign final_v2_x = temp_final_v2_x[18:8] + temp_final_v2_x[7];
	 assign final_v2_y = temp_final_v2_y[18:8] + temp_final_v2_y[7];
	 assign final_v3_x = temp_final_v3_x[18:8] + temp_final_v3_x[7];
	 assign final_v3_y = temp_final_v3_y[18:8] + temp_final_v3_y[7];
	 assign final_v4_x = temp_final_v4_x[18:8] + temp_final_v4_x[7];
	 assign final_v4_y = temp_final_v4_y[18:8] + temp_final_v4_y[7];
	 
    stageCordic inst_cordic_7 (
        .clk(clk), .reset(reset),
        
        // Entradas vêm do estágio anterior (j=6)
        .nst3_v1_x(w_v1_x[6]), .nst3_v1_y(w_v1_y[6]),
        .nst3_v2_x(w_v2_x[6]), .nst3_v2_y(w_v2_y[6]),
        .nst3_v3_x(w_v3_x[6]), .nst3_v3_y(w_v3_y[6]),
        .nst3_v4_x(w_v4_x[6]), .nst3_v4_y(w_v4_y[6]),
        .nst3_z(w_z[6]),
        .nst3_enable_cordic(w_enable[6]),
        .nst3_bubble(w_bubble[6]),
        .nst3_color(w_color[6]),
        .nst3_pixel_x(w_pixel_x[6]),
        .nst3_pixel_y(w_pixel_y[6]),
        .nst3_ref_point_x(w_ref_x[6]),
        .nst3_ref_point_y(w_ref_y[6]),
        .nst3_form(w_form[6]),
        
        .nst3_atan(ATAN_7), // <--- Valor da LUT
        .nst3_i(3'd7),          // <--- Iteração 7
        
        // Saídas vão para as portas FINAIS do módulo
        .new_nst3_v1_x(temp_final_v1_x),
        .new_nst3_v1_y(temp_final_v1_y),
        .new_nst3_v2_x(temp_final_v2_x),
        .new_nst3_v2_y(temp_final_v2_y),
        .new_nst3_v3_x(temp_final_v3_x),
        .new_nst3_v3_y(temp_final_v3_y),
        .new_nst3_v4_x(temp_final_v4_x),
        .new_nst3_v4_y(temp_final_v4_y),
        .new_nst3_z(final_z),
        .out_nst3_enable_cordic(final_enable_cordic),
        .out_nst3_bubble(out_final_bubble),
        .out_nst3_color(out_final_color),
        .out_nst3_pixel_x(out_final_pixel_x),
        .out_nst3_pixel_y(out_final_pixel_y),
        .out_nst3_ref_point_x(out_final_ref_point_x),
        .out_nst3_ref_point_y(out_final_ref_point_y),
        .out_nst3_form(out_final_form)
    );

endmodule