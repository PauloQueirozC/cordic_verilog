function poli = drawPoli(coords_x, coords_y)
  % Versão otimizada que só testa os pixels dentro da caixa delimitadora do polígono.

  % --- Configuração inicial da imagem ---
  img = 255 * ones(480, 640, 'uint8');
  img(1, :) = 0;
  img(end, :) = 0;
  img(:, 1) = 0;
  img(:, end) = 0;

  num_vertices = length(coords_x);

  % --- INÍCIO DA OTIMIZAÇÃO ---
  % 1. Encontra a caixa delimitadora (Bounding Box)
  y_min = floor(min(coords_y));
  y_max = ceil(max(coords_y));
  x_min = floor(min(coords_x));
  x_max = ceil(max(coords_x));

  % Garante que a caixa não saia dos limites da imagem
  y_min = max(1, y_min);
  y_max = min(size(img, 1), y_max);
  x_min = max(1, x_min);
  x_max = min(size(img, 2), x_max);
  % --- FIM DA OTIMIZAÇÃO ---

  % 2. Percorre APENAS os pixels dentro da caixa delimitadora
  for i = y_min:y_max  % 'i' é a linha (Y)
    for j = x_min:x_max % 'j' é a coluna (X)

      is_inside = true;
      for k = 1:num_vertices
        V1_idx = k;
        V2_idx = mod(k, num_vertices) + 1;

        x1 = coords_x(V1_idx); y1 = coords_y(V1_idx);
        x2 = coords_x(V2_idx); y2 = coords_y(V2_idx);

        m = [1, x1, y1; 1, x2, y2; 1, j, i];

        % Lógica para vértices em sentido anti-horário
        if (det(m) < 0)
          is_inside = false;
          break;
        end
      endfor

      if is_inside
        img(i, j) = 128;
      end
    endfor
  endfor

  poli = img;
end
