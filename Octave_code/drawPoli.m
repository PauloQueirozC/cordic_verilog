function poli = drawPoli(coords_x, coords_y)
  img = 255 * ones(480, 640, 'uint8');
  img(1, :) = 0;
  img(end, :) = 0;
  img(:, 1) = 0;
  img(:, end) = 0;

  altura = size(img, 1);
  largura = size(img, 2);
  num_vertices = length(coords_x);

  for i = 1:altura
    for j = 1:largura

      is_inside = true;

      for k = 1:num_vertices
        V1_idx = k;
        V2_idx = mod(k, num_vertices) + 1;

        x1 = coords_x(V1_idx);
        y1 = coords_y(V1_idx);
        x2 = coords_x(V2_idx);
        y2 = coords_y(V2_idx);

        m = [1, x1, y1; 1, x2, y2; 1, j, i];
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
