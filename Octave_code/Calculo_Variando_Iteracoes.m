clear all; close all; clc;

% --- 1. Configurações Iniciais ---
pontos_teste = {[10, 10], [80, 80]};
iteracoes_max = 8;
ang_ide = -256:255;
n_ang = length(ang_ide);
rotacao_g = ang_ide * 360 / 512;

% --- 2. Laço Externo: Itera sobre cada Ponto de Teste ---
for p = 1:length(pontos_teste)

    ponto_atual = pontos_teste{p};
    Vx_inicial = ponto_atual(1);
    Vy_inicial = ponto_atual(2);
    ponto_inicial_coluna = [Vx_inicial; Vy_inicial];

    ang_inicial_g = atan2(Vy_inicial, Vx_inicial) * (180 / pi);
    ang_ide_g_final = rotacao_g + ang_inicial_g;

    % <-- MUDANÇA 1: Adicionados vetores para guardar os desvios padrão
    resultados_rmse_ang = zeros(1, iteracoes_max);
    resultados_dp_ang = zeros(1, iteracoes_max);
    resultados_erro_dist = zeros(1, iteracoes_max);
    resultados_dp_dist = zeros(1, iteracoes_max);

    fprintf('--- Iniciando Análise para o Ponto Inicial (%.f, %.f) ---\n', Vx_inicial, Vy_inicial);

    % --- 3. Laço Interno: Itera sobre o número de iterações do CORDIC ---
    for n_iter = 1:iteracoes_max

        Vx_ide = zeros(1, n_ang); Vy_ide = zeros(1, n_ang);
        Vx_calc = zeros(1, n_ang); Vy_calc = zeros(1, n_ang);
        ang_calc = zeros(1, n_ang);

        % Rotação Ideal e CORDIC (sem alterações aqui)
        for i = 1:n_ang
            ang_rad = deg2rad(rotacao_g(i));
            R = [cos(ang_rad), -sin(ang_rad); sin(ang_rad), cos(ang_rad)];
            Vr = R * ponto_inicial_coluna;
            Vx_ide(i) = Vr(1);
            Vy_ide(i) = Vr(2);
        end
        for i = 1:n_ang
            V = cordic_fpga(Vx_inicial, Vy_inicial, ang_ide(i), n_iter);
            Vx_calc(i) = V(1);
            Vy_calc(i) = V(2);
            ang_calc(i) = atan2(V(2), V(1)) * (180 / pi);
        end

        % Cálculo dos Erros (sem alterações aqui)
        ang_erro = ang_calc - ang_ide_g_final;
        ang_erro(ang_erro > 180) = ang_erro(ang_erro > 180) - 360;
        ang_erro(ang_erro < -180) = ang_erro(ang_erro < -180) + 360;
        V_erro = sqrt((Vx_calc - Vx_ide) .^ 2 + (Vy_calc - Vy_ide) .^ 2);

        % <-- MUDANÇA 2: Calcula e armazena as 4 métricas pedidas
        resultados_rmse_ang(n_iter) = sqrt(mean(ang_erro.^2));
        resultados_dp_ang(n_iter) = std(ang_erro);
        resultados_erro_dist(n_iter) = mean(V_erro);
        resultados_dp_dist(n_iter) = std(V_erro);

    end % Fim do laço de iterações CORDIC


    % --- 4. Impressão da Tabela de Resultados para o Ponto Atual ---
    % <-- MUDANÇA 3: Tabela completamente reformatada
    fprintf('\n Tabela de Erros vs. Número de Iterações\n');
    fprintf(' ==================================================================================================\n');
    fprintf(' | Iterações | RMSE Ang. (°) | DP Ang. (°) | Erro Méd. Dist. (un) | DP Dist. (un) |\n');
    fprintf(' |-----------|---------------|-------------|----------------------|---------------|\n');

    for i = 1:iteracoes_max
        fprintf(' |     %2d    |   %f    |  %f   |      %f      |   %f    |\n', ...
                i, resultados_rmse_ang(i), resultados_dp_ang(i), resultados_erro_dist(i), resultados_dp_dist(i));
    end
    fprintf(' ==================================================================================================\n\n');

end % Fim do laço de pontos de teste
