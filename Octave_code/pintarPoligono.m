function img_modificada = pintarPoligono(p1, p2, p3, p4, cor)
  img = 255 * ones(480, 640, 'uint8');
  img(1, :) = 0;
  img(end, :) = 0;
  img(:, 1) = 0;
  img(:, end) = 0;

  [altura, largura] = size(img);
  coords_x = [p1(1), p2(1), p3(1), p4(1)];
  coords_y = [p1(2), p2(2), p3(2), p4(2)];

  mascara = poly2mask(coords_x, coords_y, altura, largura);


  img_modificada = img;


  img_modificada(mascara) = cor;
end
