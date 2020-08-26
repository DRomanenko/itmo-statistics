pkg load statistics;
    
clc;
clear;

x_min = -2.2;
x_max = 2.5;
n = 69;
c = [3.5, -4.2];
s = 1.5;

X = (x_min : (x_max - x_min) / (n - 1) : x_max)';
y = polyval(c, X);

Z = s * randn(n,1); 
Y = y + Z;
plot(X, y, X, Y);

% linear regression
xn = mean(X);
yn = mean(Y); 
cov = (X - xn)' * (Y - yn) / (n - 1);
b = cov / (std(X) ^ 2);
Yn = yn + b * (X - xn);

% matlab interpolation
m = 1;
cn = polyfit(X, Y, m);
Ynn = polyval(cn, X);
plot(X, Y, '+', X, y, X, Yn, X, Ynn, 'o');

e = Yn - Y;
sn = sqrt(e' * e / (n - 2));

ta = 1.96;
ha = ta * (sn / sqrt(n));
da = ha * (1 + (X - xn) .^ 2 / (std(X) ^ 2)) .^ (1 / 2);
Yn1 = Yn - da;
Yn2 = Yn + da;
plot(X, Yn1, X, Yn2, X, Y, 'o', X, Yn)

printf("Actual coefficients c1 = %d, c2 = %d;\n", c);
printf("Approximated coefficients: %d, %d;\n", cn);
printf("Matlab coefficients: %d, %d;\n", b, yn - b * xn); 
printf("Scalar product e and Yn: %d;\n", e' * Yn);
printf("Noise(s) = %d; Noise(sn) = %d.\n", s, sn);