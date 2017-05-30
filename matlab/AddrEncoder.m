%% Turbo Encoder Address in to Address out
x = [0:4095];
f1 = 31;
f2 = 64;
K = 4096;
PI = mod(f1.*x + f2.*x.^2,K);