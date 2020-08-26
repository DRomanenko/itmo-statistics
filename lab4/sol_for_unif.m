pkg load statistics

clc
clear

% U(2, 4)

function ans = test(a, b, n, m, k, gamma, delta, type)
  ans = 0;
  for i = 1:k
    unif = unifrnd(a, b, n, 1);
    [hist_y, hist_x] = hist(unif, m);
    
    cur_a = min(unif);
    cur_b = max(unif);
    
    cur_delta = (cur_b - cur_a) / m;
    pos = cur_a;
    
    cur_a -= delta;
    cur_b += delta;
    
    chi2 = 0;
    for q = 1:m
        pj0 = unifcdf(pos + cur_delta, cur_a, cur_b) - unifcdf(pos, cur_a, cur_b);
        chi2 += (hist_y(q) - n * pj0)^2 / (n * pj0);
        pos += cur_delta;
    endfor
    if (type == 1)
      ans += (chi2 >= chi2inv(gamma, m - 3));
    else 
      ans += (chi2 < chi2inv(gamma, m - 3));
    endif
  endfor
  ans /= k;
endfunction

% Print Plot
a = 2;
b = 4;
n = 10^6;
m = 10^2;

unif = unifrnd(a, b, n, 1);
[hist_y, hist_x] = hist(unif, m);
[stairs_x, stairs_y] = stairs(hist_x, hist_y / n * m / (max(unif) - min(unif)));
interval = (a - 1):0.01:(b + 1);
plot(interval, unifpdf(interval, a, b), stairs_x, stairs_y);

% Calc Errors
n = 10^4;
m = round(n ^ (1/3)); % m ~ 22
k = 10^3;
gamma = 0.95;

delta0 = 0;
delta1 = 0.005;
delta2 = 0.5;

printf("Expected alpha: %f\n", 1 - gamma);

error = test(a, b, n, m, k, gamma, delta0, 1);
printf("Type I error alpha: %f\n", error);

error = test(a, b, n, m, k, gamma, delta1, 2);
printf("Type II error beta with delta = %f: %f\n", delta1, error);

error = test(a, b, n, m, k, gamma, delta2, 2);
printf("Type II error beta with delta = %f: %f\n", delta2, error);