function S = cordic_unit(Vx, Vy, Z, i, atan)
  dx = fix(Vy*(2^(-i)));
  dy = fix(Vx*(2^(-i)));

  if (Z > 0)
    RVx = Vx - dx;
		RVy = Vy + dy;
		new_Z = Z - atan;
  else
    RVx = Vx + dx;
		RVy = Vy - dy;
		new_Z = Z + atan;
  endif
  S = [RVx, RVy, new_Z];
endfunction
