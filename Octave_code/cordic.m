function V = cordic(Vx, Vy, Z, iteracoes)
  V = [Vx, Vy, Z];

  for i = 0 : iteracoes-1
    V = cordic_unit_fpga(V(1), V(2), V(3), i, atan(2^(-(i-1)));
  end
endfunction
