/*
 * ======================================================================
 * MÓDULO TOP-LEVEL: VERTICE_CALCULATOR (PIPELINE DE 11 ESTÁGIOS)
 * (VERSÃO CORRIGIDA PARA VERILOG-2001)
 * ======================================================================
 */
module vertice_calculator(
    input  wire         clk,
    input  wire         reset,
    input  wire         st2_bubble,
    input  wire [8:0]   st2_color,
    input  wire [9:0]   st2_pixel_x,
    input  wire [9:0]   st2_pixel_y,
    input  wire [8:0]   ref_point_x,
    input  wire [8:0]   ref_point_y,
    input  wire         form,
    input  wire [6:0]   size,
    input  wire signed  [8:0]   angle, 
    
    output wire [9:0] v1_x,
    output wire [9:0] v1_y,
    output wire [9:0] v2_x,
    output wire [9:0] v2_y,
    output wire [9:0] v3_x,
    output wire [9:0] v3_y,
    output wire [9:0] v4_x,
    output wire [9:0] v4_y,
    output wire         out_form,
    output wire [8:0] out_st2_color,
    output wire [9:0] out_st2_pixel_x,
    output wire [9:0] out_st2_pixel_y,
    output wire         out_st2_bubble

);

    // =================================================================
    // CORREÇÃO 1: Declarar localparams para Verilog-2001 (sem array)
    // =================================================================
    localparam [8:0] ATAN_0 = 9'd64; // i=0: atan(2^0)  = 45.0   graus
    localparam [8:0] ATAN_1 = 9'd38; // i=1: atan(2^-1) = 26.57  graus
    localparam [8:0] ATAN_2 = 9'd20; // i=2: atan(2^-2) = 14.04  graus
    localparam [8:0] ATAN_3 = 9'd10; // i=3: atan(2^-3) = 7.13   graus
    localparam [8:0] ATAN_4 = 9'd5;  // i=4: atan(2^-4) = 3.58   graus
    localparam [8:0] ATAN_5 = 9'd3;  // i=5: atan(2^-5) = 1.79   graus
    localparam [8:0] ATAN_6 = 9'd1;  // i=6: atan(2^-6) = 0.895  graus
    localparam [8:0] ATAN_7 = 9'd1;  // i=7: atan(2^-7) = 0.447  graus

    // =================================================================
    // Wires de Conexão entre Estágios
    // =================================================================

    // Wires S1: Saída do Estágio 1 (Prescale)
    wire signed [18:0]  w_cord_pos_S1;
    wire signed [18:0]  w_cord_neg_S1;
    wire signed [8:0]   w_angle_S1;
    wire                w_enable_S1;
    wire [8:0]          w_color_S1;
    wire [9:0]          w_pixel_x_S1, w_pixel_y_S1;
    wire [8:0]          w_ref_x_S1, w_ref_y_S1;
    wire                w_bubble_S1, w_form_S1;

    // Wires S2: Saída do Estágio 2 (PreRotation)
    wire signed [18:0]  w_v1_x_S2, w_v1_y_S2, w_v2_x_S2, w_v2_y_S2;
    wire signed [18:0]  w_v3_x_S2, w_v3_y_S2, w_v4_x_S2, w_v4_y_S2;
    wire signed [8:0]   w_z_S2;
    wire                w_enable_S2;
    wire [8:0]          w_color_S2;
    wire [9:0]          w_pixel_x_S2, w_pixel_y_S2;
    wire [8:0]          w_ref_x_S2, w_ref_y_S2;
    wire                w_bubble_S2, w_form_S2;

    // Wires S3-S10: Saídas dos 8 Estágios CORDIC (Iterações 0 a 7)
    wire signed [18:0]  w_v1_x [0:7], w_v1_y [0:7];
    wire signed [18:0]  w_v2_x [0:7], w_v2_y [0:7];
    wire signed [18:0]  w_v3_x [0:7], w_v3_y [0:7];
    wire signed [18:0]  w_v4_x [0:7], w_v4_y [0:7];
    wire signed [8:0]   w_z [0:6];
    wire                w_enable [0:6];
    wire [8:0]          w_color [0:7];
    wire [9:0]          w_pixel_x [0:7], w_pixel_y [0:7];
    wire [8:0]          w_ref_x [0:7], w_ref_y [0:7];
    wire                w_bubble [0:7], w_form [0:7];


    // =================================================================
    // ESTÁGIO 1: Prescale
    // =================================================================
    stageCordicPrescale inst_prescale (
        .clk(clk), .reset(reset),
        
        .nst1_bubble(st2_bubble),
        .nst1_color(st2_color),
        .nst1_pixel_x(st2_pixel_x),
        .nst1_pixel_y(st2_pixel_y),
        .nst1_ref_point_x(ref_point_x),
        .nst1_ref_point_y(ref_point_y),
        .nst1_form(form),
        .size(size),
        .nst1_angle(angle),
        
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
    // ESTÁGIO 3: CORDIC Iteração 0 (Primeiro da cadeia de 8)
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
        
        .nst3_atan(ATAN_0), // <--- CORREÇÃO 2: Usar param individual
        .nst3_i(3'd0),      
        
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
            
            // CORREÇÃO 3: Selecionar o ATAN correto para Verilog-2001
            wire [8:0] current_atan;
            assign current_atan = (j==1) ? ATAN_1 : 
                                  (j==2) ? ATAN_2 : 
                                  (j==3) ? ATAN_3 : 
                                  (j==4) ? ATAN_4 : 
                                  (j==5) ? ATAN_5 : ATAN_6; // j=6
            
            stageCordic inst_cordic_j (
                .clk(clk), .reset(reset),
                
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
                
                .nst3_atan(current_atan), // <--- Usar o wire
                .nst3_i(j[2:0]),         
                
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
    // ESTÁGIO 10: CORDIC Iteração 7 (Último estágio CORDIC)
    // =================================================================
    stageCordic inst_cordic_7 (
        .clk(clk), .reset(reset),
        
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
        
        .nst3_atan(ATAN_7), // <--- Usar o param individual
        .nst3_i(3'd7),          
        
        .new_nst3_v1_x(w_v1_x[7]), .new_nst3_v1_y(w_v1_y[7]),
        .new_nst3_v2_x(w_v2_x[7]), .new_nst3_v2_y(w_v2_y[7]),
        .new_nst3_v3_x(w_v3_x[7]), .new_nst3_v3_y(w_v3_y[7]),
        .new_nst3_v4_x(w_v4_x[7]), .new_nst3_v4_y(w_v4_y[7]),
        .new_nst3_z(), 
        .out_nst3_enable_cordic(),
        .out_nst3_bubble(w_bubble[7]),
        .out_nst3_color(w_color[7]),
        .out_nst3_pixel_x(w_pixel_x[7]),
        .out_nst3_pixel_y(w_pixel_y[7]),
        .out_nst3_ref_point_x(w_ref_x[7]),
        .out_nst3_ref_point_y(w_ref_y[7]),
        .out_nst3_form(w_form[7])
    );
    
    // =================================================================
    // ESTÁGIO 11: Translation
    // =================================================================
    stageTranslation inst_translation (
        .clk(clk), .reset(reset),
        
        .cordic_v1_x(w_v1_x[7]),
        .cordic_v1_y(w_v1_y[7]),
        .cordic_v2_x(w_v2_x[7]),
        .cordic_v2_y(w_v2_y[7]),
        .cordic_v3_x(w_v3_x[7]),
        .cordic_v3_y(w_v3_y[7]),
        .cordic_v4_x(w_v4_x[7]),
        .cordic_v4_y(w_v4_y[7]),
        
        .ref_pixel_x(w_ref_x[7]), // Conectado à entrada do top-level
        .ref_pixel_y(w_ref_y[7]), // Conectado à entrada do top-level
        
        .bubble(w_bubble[7]),
        .color(w_color[7]),
        .pixel_x(w_pixel_x[7]),
        .pixel_y(w_pixel_y[7]),
        .form(w_form[7]),
        
        // Saídas finais -> Saídas do 'vertice_calculator'
        .trans_v1_x(v1_x),
        .trans_v1_y(v1_y),
        .trans_v2_x(v2_x),
        .trans_v2_y(v2_y),
        .trans_v3_x(v3_x),
        .trans_v3_y(v3_y),
        .trans_v4_x(v4_x),
        .trans_v4_y(v4_y),
        .out_form(out_form),
        .out_color(out_st2_color),
        .out_pixel_x(out_st2_pixel_x),
        .out_pixel_y(out_st2_pixel_y),
        .out_bubble(out_st2_bubble)
    );
endmodule