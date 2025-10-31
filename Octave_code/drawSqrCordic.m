function img = drawSqrCordic(size, ang)
  pkg load image;
  Ref = [640/2, 480/2];
  V1 = [-size/2, -size/2];
  V2 = [+size/2, -size/2];
  V3 = [+size/2, +size/2];
  V4 = [-size/2, +size/2];

  V1_cordic = cordic_fpga(V1(1), V1(2), ang, 8)(1:2);
  V2_cordic = cordic_fpga(V2(1), V2(2), ang, 8)(1:2);
  V3_cordic = cordic_fpga(V3(1), V3(2), ang, 8)(1:2);
  V4_cordic = cordic_fpga(V4(1), V4(2), ang, 8)(1:2);

  V1_center = V1_cordic + Ref;
  V2_center = V2_cordic + Ref;
  V3_center = V3_cordic + Ref;
  V4_center = V4_cordic + Ref;

  img = 255 * ones(480, 640, 'uint8');
  img(1, :) = 0;
  img(end, :) = 0;
  img(:, 1) = 0;
  img(:, end) = 0;

  coords_x = [V1_center(1), V2_center(1), V3_center(1), V4_center(1)];
  coords_y = [V1_center(2), V2_center(2), V3_center(2), V4_center(2)];

  img = drawPoli(coords_x, coords_y);
end


