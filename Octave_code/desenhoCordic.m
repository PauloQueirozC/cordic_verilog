function desenhoCordic(L, ang)
  if ~isnumeric(L) || L <= 0
    error('O valor de L deve ser um número positivo.');
  end
  meio_L = L / 2;
  i = 8;
  % Coordenadas X dos vértices na ordem de desenho:
  % Ponto 1 -> Ponto 2 -> Ponto 3 -> Ponto 4 -> volta ao Ponto 1
  x_coords = [ meio_L,  meio_L, -meio_L, -meio_L, meio_L ];

  % Coordenadas Y dos vértices correspondentes:
  y_coords = [ -meio_L, meio_L,  meio_L, -meio_L, -meio_L ];

  cordFpgaP1 = cordic_fpga(x_coords(1), y_coords(1), ang, i);
  cordFpgaP2 = cordic_fpga(x_coords(2), y_coords(2), ang, i);
  cordFpgaP3 = cordic_fpga(x_coords(3), y_coords(3), ang, i);
  cordFpgaP4 = cordic_fpga(x_coords(4), y_coords(4), ang, i);
  new_x_coords = [cordFpgaP1(1), cordFpgaP2(1), cordFpgaP3(1), cordFpgaP4(1), cordFpgaP1(1)]
  new_y_coords = [cordFpgaP1(2), cordFpgaP2(2), cordFpgaP3(2), cordFpgaP4(2), cordFpgaP1(2)]


  figure;
  hold on;
  plot(x_coords, y_coords, 'b-', 'LineWidth', 2);
  hold on;
  plot(new_x_coords, new_y_coords, 'r-', 'LineWidth', 2);

  % --- 4. Configuração da Visualização do Plano ---
  % 'axis' define os limites do plano cartesiano.
  axis([-320, 320, -240, 240]);

  % 'grid on' adiciona uma grade ao fundo para facilitar a leitura.
  grid on;

  % Adiciona um marcador no centro para referência (opcional, mas útil)
  hold on; % Permite adicionar mais elementos ao gráfico atual
  plot(0, 0, 'r+', 'MarkerSize', 10, 'LineWidth', 2); % 'r+' é uma cruz vermelha
  hold off; % Volta ao comportamento normal de substituir o gráfico

  % Adiciona títulos e rótulos para clareza
  title(['Quadrado de Lado L = ', num2str(L), ' Centrado na Origem']);
  xlabel('Eixo X');
  ylabel('Eixo Y');

  % Garante que a proporção dos eixos seja a definida pelo comando axis.
  % O comando 'axis equal' faria o quadrado parecer um quadrado, mas alteraria
  % os limites definidos, então não o usamos aqui para seguir a regra.
  pbaspect([320 240 1]); % Força a proporção da caixa do plot para 4:3

end
