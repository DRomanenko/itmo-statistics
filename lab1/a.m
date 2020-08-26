pkg load statistics;

function [res] = g(x)
  res = abs(x);
endfunction

function [res] = g1(x)
  res = sqrt(3 * pi) * g(x);
endfunction

function [res] = f(x)
  res = g(x) * exp(-(x - 2).^2 / 3);
endfunction

function monte_carlo_a(n)
  my_gamma = 0.95;
  
  u = 2;
  sigma = sqrt(3 / 2);
  
  Q = norminv((my_gamma + 1) / 2);
  X = normrnd(u, sigma, 1, n);
  
  F_x = g1(X);
  V = mean(F_x);
  my_delta = (std(F_x) * Q) / sqrt(n);
  
  printf("N = %d\n", n);
  printf("Value is %d\n", V);
  printf("Confidence interval: [%d, %d]\n", V - my_delta, V + my_delta);
  printf("Delta is %d\n\n", my_delta);
endfunction

printf("Sample answer = %d\n\n", quad(@f, -inf, inf));
monte_carlo_a(10000);
monte_carlo_a(1000000);