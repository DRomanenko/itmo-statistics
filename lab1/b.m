pkg load statistics;

function res = f(x)
  res = (x.^2 + 2).^(1/4);
endfunction

function monte_carlo_b(n)
  my_gamma = 0.95;
  
  L = 2;
  R = 7;
  
  Q = norminv((my_gamma + 1) / 2);
  X = unifrnd(L, R, 1, n);
  
  F_x = f(X) * (R - L);
  V = mean(F_x);
  my_delta = (std(F_x) * Q) / sqrt(n);
  
  printf("N = %d\n", n);
  printf("Value is %d\n", V);
  printf("Confidence interval: [%d, %d]\n", V - my_delta, V + my_delta);
  printf("Delta is %d\n\n", my_delta);
endfunction

printf("Sample answer = %d\n\n", quad(@f, 2, 7));
monte_carlo_b(10000);
monte_carlo_b(1000000);