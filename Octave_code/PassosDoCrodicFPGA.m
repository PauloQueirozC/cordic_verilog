clear all; close all; clc;
% --- 1. Configurações ---
fator_conv = 512 / 360;      % Fator de conversão de graus para inteiro
angulos_desejados_deg = -180:0.5:180; % Faixa de ângulos para testar
iteracoes = 8;               % Número de iterações do CORDIC
Vx_inicial = 1000;           % Ponto inicial (1000, 0) para rotacionar
Vy_inicial = 0;

% Vetores para guardar os resultados
angulos_alcancados_deg = [];
total_pontos = length(angulos_desejados_deg);

fprintf('Iniciando análise de %d ângulos...\n', total_pontos);

% --- 2. Laço Principal de Teste ---
for i = 1:total_pontos
    ang_deg = angulos_desejados_deg(i);

    % Converte o ângulo em graus para o formato inteiro que o módulo espera
    Z_int = round(ang_deg * fator_conv);

    % Garante que a entrada está no range permitido [-256, 255]
    Z_int = max(-256, min(255, Z_int));

    % Executa a sua função CORDIC
    V_final = cordic_fpga(Vx_inicial, Vy_inicial, Z_int, iteracoes);
    Rx = V_final(1);
    Ry = V_final(2);

    % Calcula o ângulo real alcançado a partir do ponto final
    ang_alcancado_rad = atan2(Ry, Rx);
    ang_alcancado_deg = ang_alcancado_rad * (180 / pi);

    % Armazena o resultado
    angulos_alcancados_deg(end+1) = ang_alcancado_deg;


end

fprintf('Análise concluída.\n');

% --- 3. Cálculo do Erro ---
erro_deg = angulos_alcancados_deg - angulos_desejados_deg;

% Corrige o "wrap-around" do erro em +/-180 graus
erro_deg(erro_deg > 180) = erro_deg(erro_deg > 180) - 360;
erro_deg(erro_deg < -180) = erro_deg(erro_deg < -180) + 360;

% --- 4. Geração dos Gráficos ---

% GRÁFICO 1: Desejado vs. Alcançado
figure(1);
plot(angulos_desejados_deg, angulos_alcancados_deg, 'b.', 'MarkerSize', 5);
hold on;
plot(angulos_desejados_deg, angulos_desejados_deg, 'r-', 'LineWidth', 2);
grid on;
title('Análise de Rotação CORDIC: Ângulo Desejado vs. Ângulo Alcançado');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Ângulo Real (Graus)');
legend('Alcançado (CORDIC)', 'Ideal');
axis([-180 180 -180 180]);

% GRÁFICO 2: Erro de Rotação
figure(2);
plot(angulos_desejados_deg, erro_deg, 'g');
grid on;
title('Erro de Rotação do Algoritmo CORDIC');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Erro (Graus)');
