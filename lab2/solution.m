pkg load statistics

clc
clear

m = 10 ^ 2;
n = 10 ^ 4;
mu = -1;
sigma = 0.5;
gamma = 0.95;
t0 = -1;

X = normrnd(mu, sigma, n, m);
f = mean(X < t0);

Q = norminv((1 + gamma) / 2);
diff = Q * sqrt(f .* (1 - f) / n);

x = 1:1:m;
L = f - diff;
R = f + diff;
F = normcdf(t0, mu, sigma);
plot(x, L, 'r*-', x, R, 'g*-', x, F, 'b.-')
grid

misses = sum(L > F) + sum(R < F);
printf("Number of points hit: %d out of %d\n", m - misses, m);