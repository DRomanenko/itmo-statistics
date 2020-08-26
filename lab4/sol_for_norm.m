pkg load statistics

clc
clear

% N(1, 4)

function ans = calc_for_type_error(chi2, gamma, sigma, type)
  if (type == 1)
    ans = (chi2 >= chi2inv(gamma, sigma));
  else 
    ans = (chi2 < chi2inv(gamma, sigma));
  endif
endfunction

function ans = test(mu, sigma, n, m, k, gamma, delta, mod, type)
  result = 0;
  for i = 1:k
    norm = normrnd(mu, sigma, n, 1);
    
    left = min(norm);
    curr_delta = (max(norm) - left) / m;
    [hist_y, hist_x] = hist(norm, m);
    curr_mu = mean(norm);
    curr_sigma = std(norm);
    
    if (mod == 0) % simple
      chi2 = 0;
      for q = 1:m
        pj0 = normcdf(left + curr_delta, curr_mu, curr_sigma) - normcdf(left, curr_mu, curr_sigma);
        chi2 += (hist_y(q) - n * pj0)^2 / (n * pj0);
        left += curr_delta;
      endfor
      result += calc_for_type_error(chi2, gamma, m - 3, type);
    else % corrected
      curr_mu += delta;
      parts = 0;
      j = 1;
      chi2 = 0;
      while (j <= m)
        nj = hist_y(j);
        rt = left + curr_delta;
        while (j < m && nj < 6)
          j++;
          nj += hist_y(j);
          rt += curr_delta;
        endwhile
        pj0 = normcdf(rt, curr_mu, curr_sigma) - normcdf(left, curr_mu, curr_sigma);
        chi2 += (nj - n * pj0)^2 / (n * pj0);
        left = rt;
        parts++;
        j++;
      endwhile
      result += calc_for_type_error(chi2, gamma, parts - 3, type);
    endif
  endfor
  ans = result / k;
endfunction


% Print Plot
mu = 1;
sigma = 4;
n = 10^6;
m = 10^2;

norm = normrnd(mu, sigma, n, 1);
[hist_y, hist_x] = hist(norm, m);
[stairs_x, stairs_y] = stairs(hist_x, hist_y / n * m / (max(norm) - min(norm)));
interval = min(norm):0.01:max(norm);
plot(interval, normpdf(interval, mu, sigma), stairs_x, stairs_y);

% Calc Errors
n = 10^4;
m = round(n ^ (1/3)); % m ~ 22
k = 10^3;
gamma = 0.95;

delta0 = 0;
delta1 = 0.005;
delta2 = 0.5;

printf("Expected alpha: %f\n", 1 - gamma);

error = test(mu, sigma, n, m, k, gamma, delta0, 0, 1);
printf("Type I error alpha: %f\n", error);

error = test(mu, sigma, n, m, k, gamma, delta0, 1, 1);
printf("Type I error alpha (corrected): %f\n", error);

error = test(mu, sigma, n, m, k, gamma, delta1, 1, 2);
printf("Type II error beta with delta = %f: %f\n", delta1, error);

error = test(mu, sigma, n, m, k, gamma, delta2, 1, 2);
printf("Type II error beta with delta = %f: %f\n", delta2, error);