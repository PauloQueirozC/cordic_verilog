function V = cordic_fpga(Vx, Vy, Z, iteracoes)
  atan = [64, 38, 20, 10, 5, 3, 1, 0];

  # Pre_Cordic
  ## PreScale
  ajustePF = 2^4;
  Vx = Vx * ajustePF;
  Vy = Vy * ajustePF;

  Vx = fix(Vx * 2^-1) + fix(Vx * 2^-4) + fix(Vx * 2^-5) + fix(Vx * 2^-7) + fix(Vx * 2^-8);
  Vy = fix(Vy * 2^-1) + fix(Vy * 2^-4) + fix(Vy * 2^-5) + fix(Vy * 2^-7) + fix(Vy * 2^-8);

  ## Rotação Inicial
  if Z >= 128
    temp_Vx = Vx;
    Vx = -Vy;
		Vy =  temp_Vx;
		Z  =  Z - 128;
  elseif Z <= (-128)
    temp_Vx = Vx;
    Vx =  Vy;
		Vy = -temp_Vx;
		Z  =  Z + 128;
  endif

  # Cordic
  V = [Vx, Vy, Z];
  if(Z != 0)
    for i = 0 : iteracoes-1
      V = cordic_unit_fpga(V(1), V(2), V(3), i, atan(i+1));
    end
  endif
  V = [fix(V(1)/ajustePF), fix(V(2)/ajustePF), V(3)];
endfunction
