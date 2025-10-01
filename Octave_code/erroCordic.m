clear all; close all; clc;

all_ang = -256:255;
iteracoes = 8;
Vx = 10;
Vy = 10;

all_ang_g = all_ang * 360 / 512 + 45;

ang_calc = [];

n_points = length(all_ang);
for i = 1:n_points
  V = cordic_fpga(Vx, Vy, all_ang(i), iteracoes);
  ang_calc(end+1) = atan2(V(2), V(1)) * (180 / pi);
end

erro = ang_calc - all_ang_g;
erro(erro > 180) = erro(erro > 180) - 360;
erro(erro < -180) = erro(erro < -180) + 360;

mse = mean(erro.^2);
rmse = sqrt(mse);
fprintf('Erro Quadrático Médio (MSE)        : %f (graus^2)\n', mse);
fprintf('Raiz do Erro Quadrático Médio (RMSE): %f (graus)\n', rmse);

% GRÁFICO 1: Desejado vs. Alcançado
figure(1);
plot(all_ang_g, ang_calc, 'b.', 'MarkerSize', 5);
hold on;
plot(all_ang_g, all_ang_g, 'r-', 'LineWidth', 2);
grid on;
title('Análise de Rotação CORDIC: Ângulo Desejado vs. Ângulo Alcançado');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Ângulo Real (Graus)');
legend('Alcançado (CORDIC)', 'Ideal');
axis([-180 180 -180 180]);

% GRÁFICO 2: Erro de Rotação
figure(2);
plot(all_ang_g, erro, 'g');
grid on;
title('Erro de Rotação do Algoritmo CORDIC');
xlabel('Ângulo Solicitado (Graus)');
ylabel('Erro (Graus)');




