% Script para analisar a precisão da função CORDIC

clear all; close all; clc;

% --- 1. Configuração do Teste ---
input_angles_int = -128:128; % Todas as entradas inteiras possíveis
N_iteracoes = 8;          % Número de iterações do CORDIC

% Ponto inicial para rotacionar. Um vetor na horizontal (ângulo 0) é ideal.
% Usamos um valor grande para simular melhor a aritmética de ponto fixo.
Vx_inicial = 10;
Vy_inicial = 0;

% Vetor para armazenar os ângulos alcançados (em graus)
achieved_angles_deg = [];

fprintf('Iniciando análise CORDIC para %d ângulos de entrada...\n', length(input_angles_int));

% --- 2. Laço de Execução e Coleta de Dados ---
for ang_desejado_int = input_angles_int
  % Executa o algoritmo CORDIC para o ponto e ângulo atuais
  R = cordic_fpga(Vx_inicial, Vy_inicial, ang_desejado_int, N_iteracoes)

  % Calcula o ângulo real do ponto de saída usando atan2
  % atan2 retorna o ângulo em radianos, tratando todos os quadrantes
  angle_rad = atan2(R(2), R(1));

  % Converte o ângulo de radianos para graus
  angle_deg = angle_rad * (180 / pi);

  % Armazena o resultado
  achieved_angles_deg(end+1) = angle_deg;
end

fprintf('Análise completa.\n\n');

% --- 3. Análise dos Ângulos Únicos ---
unique_angles = unique(achieved_angles_deg);
num_inputs = length(input_angles_int);
num_unique_outputs = length(unique_angles);

fprintf('Número total de ângulos de entrada: %d\n', num_inputs);
fprintf('Número de ângulos de saída únicos alcançados: %d\n', num_unique_outputs);
fprintf('Isso mostra que o CORDIC quantiza os ângulos de saída.\n\n');

% --- 4. Preparação para a Plotagem ---
% Converte a entrada inteira (-64 a 64) para o ângulo em graus que ela representa
% A escala é linear: 64 -> 90 graus
input_angles_deg = input_angles_int * (45 / 64);

% --- 5. Plotagem dos Resultados ---

% Gráfico 1: Ângulo Alcançado vs. Ângulo Desejado
figure;
plot(input_angles_deg, achieved_angles_deg, 'b.', 'MarkerSize', 10); % Pontos azuis
hold on;
plot(input_angles_deg, input_angles_deg, 'r-', 'LineWidth', 2); % Linha vermelha ideal (y=x)
grid on;
title('Análise de Precisão CORDIC: Alcançado vs. Desejado');
xlabel('Ângulo Desejado (Graus)');
ylabel('Ângulo Alcançado (Graus)');
legend('Ângulo Alcançado (CORDIC)', 'Resultado Ideal');
axis([-100 100 -100 100]); % Ajusta o zoom do gráfico

% Gráfico 2: Erro de Rotação
figure;
error_deg = achieved_angles_deg - input_angles_deg;
plot(input_angles_deg, error_deg, 'g-', 'LineWidth', 1.5);
grid on;
title('Erro de Rotação CORDIC');
xlabel('Ângulo Desejado (Graus)');
ylabel('Erro (Graus)');
%axis([-100 100 -1 1]); % Ajusta o zoom do eixo Y para ver o erro
