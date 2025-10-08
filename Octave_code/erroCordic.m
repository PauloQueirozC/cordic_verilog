clear all; close all; clc;

% Iniciando Variaveis
ang_ide = -256:255;
Vx_ide = [];
Vy_ide = [];
iteracoes = 8;
Vx = 80;
Vy = 80;

ang_ide_g = ang_ide * 360 / 512;
ang_ide_g_final = ang_ide_g  + atan2(Vy, Vx) * (180 / pi);
n_ang = length(ang_ide);

ang_calc = [];
Vx_calc = [];
Vy_calc = [];

for i = 1:n_ang
  ang_rad = deg2rad(ang_ide(i) * (360 / 512));
  Vr = [cos(ang_rad), -sin(ang_rad); sin(ang_rad), cos(ang_rad)]*[Vx; Vy];
  Vx_ide(end+1) = Vr(1);
  Vy_ide(end+1) = Vr(2);
end

% Calculo do Cordic

for i = 1:n_ang
  V = cordic_fpga(Vx, Vy, ang_ide(i), iteracoes);
  ang_calc(end+1) = atan2(V(2), V(1)) * (180 / pi);
  Vx_calc(end+1) = V(1);
  Vy_calc(end+1) = V(2);
end

% Calculo do Erro
ang_erro = ang_calc - ang_ide_g_final;
ang_erro(ang_erro > 180) = ang_erro(ang_erro > 180) - 360;
ang_erro(ang_erro < -180) = ang_erro(ang_erro < -180) + 360;

Vx_erro = Vx_calc - Vx_ide;
Vy_erro = Vy_calc - Vy_ide;
V_erro = sqrt(Vx_erro .^ 2 + Vy_erro .^ 2);


% Calculo do MSE e RMSE
ang_mse = mean(ang_erro.^2);
ang_rmse = sqrt(ang_mse);

V_rmse = mean(V_erro);

% Calculo da Variancia e Desvio padrão
ang_var = var(ang_erro);
ang_dp  = std(ang_erro);

V_var = var(V_erro);
V_dp  = std(V_erro);
% Prints
fprintf('Erro medio Ponto: %f (px)\n', V_rmse);
%fprintf('Vari. Ponto     : %f (px^2)\n', V_var);
fprintf('Des. Pad. Ponto : %f (px)\n', V_dp);
%fprintf('MSE angulo      : %f (graus^2)\n', ang_mse);
fprintf('RMSE angulo     : %f (graus)\n', ang_rmse);
%fprintf('Vari. angulo    : %f (graus^2)\n', ang_var);
fprintf('Des. Pad. angulo: %f (graus)\n', ang_dp);

% GRÁFICO 1: Desejado vs. Alcançado
figure(1);
plot(ang_ide_g_final, ang_calc, 'b.', 'MarkerSize', 5);
hold on;
plot(ang_ide_g_final, ang_ide_g_final, 'r-', 'LineWidth', 2);
grid on;
title('Análise de Rotação CORDIC: Ângulo Desejado vs. Ângulo Alcançado');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Ângulo Real (Graus)');
legend('Alcançado (CORDIC)', 'Ideal');
axis([-180 180 -180 180]);

% GRÁFICO 2: Erro de Rotação
figure(2);
plot(ang_ide_g, ang_erro, 'g');
grid on;
title('Erro de Rotação do Algoritmo CORDIC');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Erro (Graus)');

% <-- SUGESTÃO 1: Adicionar os gráficos de erro de coordenadas e distância
figure(3);
plot(ang_ide_g, Vx_erro, 'm');
grid on;
title('Erro de Coordenada em X');
xlabel('Ângulo Solicitado (Graus)'); ylabel('Erro em X'); axis tight;

figure(4);
plot(ang_ide_g, Vy_erro, 'c');
grid on;
title('Erro de Coordenada em Y');
xlabel('Ângulo Solicitado (Graus)'); ylabel('Erro em Y'); axis tight;

figure(5);
plot(ang_ide_g, V_erro, 'k');
grid on;
title('Erro de Distância Euclidiana');
xlabel('Ângulo Solicitado (Graus)'); ylabel('Distância do Erro'); axis tight;



