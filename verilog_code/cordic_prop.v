`define theta_0_9b 9'd64 // atan(2^0) = 45°    -> (45/360)*512 = 64
`define theta_1_9b 9'd38 // atan(2^-1)= 26.56° -> (26.56/360)*512 = 38
`define theta_2_9b 9'd20 // atan(2^-2)= 14.04° -> (14.04/360)*512 = 20
`define theta_3_9b 9'd10 // atan(2^-3)= 7.12°  -> (7.12/360)*512 = 10
`define theta_4_9b 9'd5  // atan(2^-4)= 3.58°  -> (3.58/360)*512 = 5
`define theta_5_9b 9'd3  // atan(2^-5)= 1.79°  -> (1.79/360)*512 = 3
`define theta_6_9b 9'd1  // atan(2^-6)= 0.90°  -> (0.90/360)*512 = 1
`define theta_7_9b 9'd0  // atan(2^-7)= 0.45°  -> (0.45/360)*512 = 1

module cordic_prop (
    // Saídas
    cos_z0, sin_z0, done,
    // Entradas
    z0, start, clock, reset
);

    // --- Declaração de Portas ---
    input signed [8:0] z0;
    input start;
    input clock;
    input reset;
    output signed [10:0] cos_z0;
    output signed [10:0] sin_z0;
    output done;

    // --- Registradores de Saída ---
    reg signed [10:0] sin_z0;
    reg signed [10:0] cos_z0;
    reg done;

    // --- Registradores Internos ---
    reg [3:0] i;
    reg  state;
    reg signed [8:0] dz;
    reg signed [10:0] dx;
    reg signed [10:0] dy;
    reg signed [10:0] y;
    reg signed [10:0] x;
    reg signed [8:0] z;

    // MUDANÇA: Tabela de ângulos com 9 bits
    wire signed [8:0] atan_table [0:7];

    assign atan_table[0] = `theta_0_9b;
    assign atan_table[1] = `theta_1_9b;
    assign atan_table[2] = `theta_2_9b;
    assign atan_table[3] = `theta_3_9b;
    assign atan_table[4] = `theta_4_9b;
    assign atan_table[5] = `theta_5_9b;
    assign atan_table[6] = `theta_6_9b;
    assign atan_table[7] = `theta_7_9b;

    // Constante para 90 graus em 9 bits: (90/360)*512 = 128
    localparam PI_DIV_2 = 9'd128;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state <= 1'b0;
            cos_z0 <= 0;
            sin_z0 <= 0;
            done <= 0;
            x <= 0;
            y <= 0;
            z <= 0;
            i <= 0;
        end
        else begin
            case (state)
                1'b0: begin
                    if (start) begin
                        // MUDANÇA: Lógica de quadrantes restaurada para 9 bits
                        // Usa z0[8:7] para determinar o quadrante
                        if(z0[8:7] == 2'b00 || z0[8:7] == 2'b11) begin // Q1 (0-89) e Q4 (270-359)
                            x <= 311; // 1000 / 1.646
                            y <= 0;
                            z <= z0;
                        end else if(z0[8:7] == 2'b01) begin // Q2 (90-179)
                            x <= 0;
                            y <= 311;
                            z <= z0 - PI_DIV_2; // Subtrai 90 graus
                        end else if(z0[8:7] == 2'b10) begin // Q3 (180-269)
                            x <= 0;
                            y <= 311;
                            z <= z0 + PI_DIV_2; // Adiciona 90 graus (para rotação reversa)
                        end
                        
                        i <= 0;
                        done <= 0;
                        state <= 1'b1;
                    end
                end
                
                1'b1: begin
                    dx = (y >>> i);
                    dy = (x >>> i);
                    dz = atan_table[i];

                    if ((z >= 0)) begin
                        x <= x - dx;
                        y <= y + dy;
                        z <= z - dz;
                    end
                    else begin
                        x <= x + dx;
                        y <= y - dy;
                        z <= z + dz;
                    end

                    if (i == 7) begin
                        // MUDANÇA: Correção de sinal para Q3 restaurada
                        if(z0[8:7] == 2'b10) begin
                            cos_z0 <= -x;
                            sin_z0 <= -y;
                        end else begin
                            cos_z0 <= x;
                            sin_z0 <= y;
                        end
                        
                        state <= 1'b0;
                        done <= 1;
                    end else begin
                        i <= i + 1;
                    end
                end
            endcase
        end
    end
endmodule