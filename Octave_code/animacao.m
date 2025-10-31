% Limpa a tela, variáveis e fecha janelas anteriores
clear; clc; close all;

% --- Parâmetros da Animação ---
tamanho_triangulo = 160; % Define o tamanho do triângulo
passo_angulo = 1;        % De quanto em quanto o ângulo vai incrementar a cada frame
tempo_pausa = 0.001;      % Pausa em segundos entre os frames (controle de FPS)

% --- Inicialização ---
angulo_int = -128; % O valor inicial do nosso ângulo inteiro
printf("Iniciando a animação... Pressione Ctrl+C na janela de comandos para parar.\n");

% Cria a janela gráfica ANTES de começar o laço
figure;

% --- Laço Principal da Animação ---
while true

  % 1. DESENHA O FRAME
  % Chama a função de alto nível para gerar a imagem com o ângulo atual
  img = drawSqrCordic(tamanho_triangulo, angulo_int);

  % 2. EXIBE O FRAME
  % Mostra a imagem na tela. O 'imshow' é rápido o suficiente para animações
  imshow(img);
  title(sprintf('Animacao Rotacao | Angulo: %d', angulo_int)); % Mostra o ângulo no título

  % 3. PAUSA
  % Essencial para que a animação não seja rápida demais e para que a janela gráfica atualize
  pause(tempo_pausa);

  % 4. ATUALIZA O ESTADO
  % Incrementa o ângulo para o próximo frame
  angulo_int = angulo_int + passo_angulo;

  % Faz o ângulo "dar a volta" quando ultrapassa o limite
  if (angulo_int > 127)
    angulo_int = -128;
  end

end
