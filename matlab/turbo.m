clear;   clc; close all; 

%K    = 1008;  % Block Length
%f1   = 55; 
%f2   = 84; 

K    = 40;  % Block Length
f1   = 3; 
f2   = 10; 

index = 1:K; 
intrlvI = mod(f1.*index + f2.*index.^2,K)+1;


hTEnc = comm.TurboEncoder('TrellisStructure', poly2trellis(4, [13 15], 13), 'InterleaverIndices', intrlvI);

load out.mat
load data.mat

%data = randi([0 1], K, 1);

%encodedData = step(hTEnc, data(1:K));
encodedData = step(hTEnc, randi([0,1],K,1));

sum(encodedData == OUT(:,1))

data_int = data(intrlvI);
Z = OUT(:,1); 

encodedData(121:132).'

