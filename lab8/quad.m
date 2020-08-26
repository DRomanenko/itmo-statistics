pkg load statistics;
    
clc;
clear;

x_min = -2.2; 
x_max = 2.5;
n = 69;
a = [1.7, -2.4, -3.6];
s = 1.5;

X = (x_min : (x_max - x_min) / (n - 1) : x_max)';
y = polyval(a, X);

Z = s * randn(n, 1); 
Y = y + Z;
plot(X, y, X, Y, '+');

m = 2;
an = polyfit(X, Y, m);
Yn = polyval(an, X);
plot(X, Y, '+', X, y, X, Yn, 'o');

e = Yn - Y;
printf("Actual coefficients a1 = %d, a2 = %d, a3 = %d;\n", a);
printf("Approximated coefficients: %d, %d, %d;\n", an);
printf("Scalar product e and Yn: %d;\n", e' * Yn);
printf("Noise(s) = %d; Noise(sn) = %d.\n", s, sqrt(e' * e / (n - 2)));