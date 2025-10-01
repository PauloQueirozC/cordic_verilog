`timescale 1ns / 1ps

module tb_cordic; // Renomeei o módulo para corresponder ao que o Quartus espera

    // --- Sinais para conectar ao DUT ---
    reg clock;
    reg reset;
    reg start;
    reg signed [8:0] z0_in;

    wire signed [10:0] cos_out;
    wire signed [10:0] sin_out;
    wire               done;

    // --- Variáveis do Testbench ---
    integer i;
    integer file_handle;

    // --- CORREÇÃO: Variáveis movidas para o topo do bloco ---
    // Estas variáveis agora são declaradas aqui, antes de qualquer ação.
    real angle_deg;
    real ideal_cos_real;
    integer ideal_cos_int;
    integer error;

    // --- Instanciação do Módulo a ser Testado (DUT) ---
    // Verifique se o nome do módulo aqui é o mesmo do seu arquivo de design
    cordic_prop dut (
        .cos_z0(cos_out),
        .sin_z0(sin_out),
        .done(done),
        .z0(z0_in),
        .start(start),
        .clock(clock),
        .reset(reset)
    );

    // --- Geração do Clock ---
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // --- Sequência de Teste Principal ---
    initial begin
        $display("Iniciando o testbench completo do CORDIC...");
        file_handle = $fopen("cordic_results.txt", "w");
        $fdisplay(file_handle, "z0_int,Angle_Deg,HW_Cosine,Ideal_Cosine,Error");

        reset = 1'b1;
        start = 1'b0;
        z0_in = 0;
        #20;
        reset = 1'b0;
        #20;
        //reset = 1'b1;

        for (i = 0; i < 512; i = i + 1) begin
            z0_in = i;
            #10;
            start = 1'b1;
            #1;
            start = 1'b0;

            @(posedge done);

            // Agora apenas usamos as variáveis, sem declará-las
            begin
                angle_deg = (i / 512.0) * 360.0;
                ideal_cos_real = 512 * $cos(angle_deg * 3.14159265 / 180.0);
                ideal_cos_int = $rtoi(ideal_cos_real);
                error = cos_out - ideal_cos_int;

                $fdisplay(file_handle, "%d,%f,%d,%d,%d",
                    i, angle_deg, cos_out, ideal_cos_int, error);
            end

            if (i % 50 == 0) begin
                $display("Simulando entrada z0 = %d", i);
            end
        end

        $display("Simulação concluída. Resultados salvos em cordic_results.txt");
        $fclose(file_handle);
        $finish;
    end

endmodule