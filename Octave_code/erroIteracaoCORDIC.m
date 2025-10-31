for i = 0:10
  printf("%d | %f", i, atand(2^(-i)));
  erro = 0;
  for j = (i+1):100
    erro += atand(2^-j);
  endfor
  printf(" | %f\n", erro);
endfor
