% ============================================================================
% Testbench para o Módulo Verilog CORDIC de 9 bits (VERSÃO CORRIGIDA)
%
% Autor: Gemini AI
% Data:  20 de setembro de 2025
%
% Descrição:
% CORREÇÃO: As variáveis internas foram padronizadas para o tipo int32 para
% evitar conflitos de tipo durante as operações aritméticas. A lógica de
% "wrap-around" continua a simular os limites dos registradores.
% ============================================================================

clear all;
clc;
close all; % Fecha todas as janelas de gráficos anteriores

% --- 1. Configuração do Testbench ---
z0_range = 0:511; % Testa todos os valores de entrada de 9 bits
num_points = length(z0_range);

% Pré-alocação de vetores para armazenar os resultados
angle_degrees = zeros(1, num_points);
hardware_cos_results = zeros(1, num_points, 'int16'); % Armazena como int16
ideal_cos_results = zeros(1, num_points);

fprintf('Iniciando testbench completo para %d pontos...\n', num_points);

% --- 2. Laço Principal de Teste ---
for i = 1:num_points
    z0 = z0_range(i);
    angle_degrees(i) = (z0 / 512) * 360;

    [cos_hw, ~] = cordic_9bit_simulation(z0);
    hardware_cos_results(i) = cos_hw;

    ideal_cos_results(i) = 1000 * cosd(angle_degrees(i));

    if mod(i, 50) == 0
        fprintf('Progresso: %d / %d\n', i, num_points);
    end
end

fprintf('Testbench concluído.\n');

% --- 3. Cálculo do Erro ---
% CORREÇÃO: Converte os resultados para double antes de subtrair
error = double(hardware_cos_results) - ideal_cos_results;
mean_abs_error = mean(abs(error));
max_abs_error = max(abs(error));

fprintf('\nAnálise de Erro:\n');
fprintf('Erro Médio Absoluto: %.2f\n', mean_abs_error);
fprintf('Erro Máximo Absoluto: %.2f\n\n', max_abs_error);

% --- 4. Geração dos Gráficos ---
figure(1);
plot(angle_degrees, hardware_cos_results, 'b-', 'LineWidth', 2);
hold on;
plot(angle_degrees, ideal_cos_results, 'r--', 'LineWidth', 1);
hold off;
title('Resultado do CORDIC Hardware vs. Cosseno Ideal');
xlabel('Ângulo de Entrada (Graus)');
ylabel('Valor do Cosseno (Escalado por 1000)');
legend('Hardware Simulado', 'Matemático Ideal');
grid on;
axis([0 360 -1100 1100]);

figure(2);
plot(angle_degrees, error, 'k-');
hold on;
line(xlim, [0 0], 'Color', 'r', 'LineStyle', '--');
hold off;
title(sprintf('Erro Absoluto (Hardware - Ideal)\nErro Máx: %.0f | Erro Médio: %.2f', max_abs_error, mean_abs_error));
xlabel('Ângulo de Entrada (Graus)');
ylabel('Diferença (Erro)');
grid on;
axis([0 360 -10 10]);
