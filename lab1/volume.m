pkg load statistics;

function [res] = f (x)
  res = x.^ pi;
endfunction

function monte_carlo_volume(n)
  my_gamma = 0.95;
  k = 5;
  c = 1.4;
  X = rand(k, n);
  F_x = sum(f(X));
  my_volume = mean(F_x <= c);
  
  T = norminv((my_gamma + 1) / 2);
  my_delta = T * sqrt(my_volume * (1 - my_volume) / n);
  
  printf("N = %d\n", n);
  printf("Volume is %dL\n", my_volume);
  printf("Confidence interval: [%d, %d]\n", my_volume - my_delta, my_volume + my_delta);
  printf("Delta is %d\n\n", my_delta);
endfunction

monte_carlo_volume(10000);
monte_carlo_volume(1000000);