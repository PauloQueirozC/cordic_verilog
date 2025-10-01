function V = cordic_fpga(Vx, Vy, Z, iteracoes)
  atan = [64, 38, 20, 10, 5, 3, 1, 0];



  ganho = 2^4;
  Vx = Vx * ganho;
  Vy = Vy * ganho;

  Vx = fix(Vx * 2^-1) + fix(Vx * 2^-4) + fix(Vx * 2^-5) + fix(Vx * 2^-7) + fix(Vx * 2^-8);
  Vy = fix(Vy * 2^-1) + fix(Vy * 2^-4) + fix(Vy * 2^-5) + fix(Vy * 2^-7) + fix(Vy * 2^-8);

  V = [Vx, Vy, Z];
  for i = 0 : iteracoes-1
    V = cordic_unit_fpga(V(1), V(2), V(3), i, atan(i+1));
  end
  V = [fix(V(1)/ganho), fix(V(2)/ganho), V(3)]
endfunction
