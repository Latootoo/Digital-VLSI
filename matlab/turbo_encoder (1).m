clc; clear; close all; 


%K    = 1008;  % Block Length
%f1   = 55; 
%f2   = 84; 

K    = 40;  % Block Length
f1   = 3; 
f2   = 10; 


N = 100;   % Bits

% Initialize 
TOP.In = 0; 
TOP.D1 = 0; 
TOP.D2 = 0; 
TOP.D3 = 0; 
TOP.n1 = 0; 
TOP.n2 = 0; 
TOP.n3 = 0; 
TOP.n4 = 0; 

BOT.In = 0; 
BOT.D1 = 0; 
BOT.D2 = 0; 
BOT.D3 = 0; 
BOT.n1 = 0; 
BOT.n2 = 0; 
BOT.n3 = 0; 
BOT.n4 = 0;

out1 = zeros(ceil(N/K), K);
out2 = zeros(ceil(N/K), K); 
out3 = zeros(ceil(N/K), K); 
OUT  = zeros(ceil(N/K), 3*K+12); 

x   = zeros(ceil(N/K), 3); 
z   = zeros(ceil(N/K), 3); 
z_p = zeros(ceil(N/K), 3); 
x_p = zeros(ceil(N/K), 3); 



Input = zeros(K,1); 
Input_Interleaved = zeros(K,1); 


data = randi([0,1],N,1); 


rem = mod(N,K);


loop_size = floor(N/K); 

ind = 1; 


index = 1:K; 
new_index = mod(f1.*index + f2.*index.^2,K)+1; 

% MAIN LOOP 

for i = 1:loop_size 
      
 Input = data(ind:ind-1+K); 
 Input_Interleaved = Input(new_index);
 
 for ii = 1:K
     % Update Registers 
     TOP.D3 = TOP.D2;
     TOP.D2 = TOP.D1;
     TOP.D1 = TOP.n1;
     TOP.In = Input(ii); 
 
     BOT.D3 = BOT.D2;
     BOT.D2 = BOT.D1;
     BOT.D1 = BOT.n1;
     BOT.In = Input_Interleaved(ii); 

     % Calculate
     TOP.n4 = mod(TOP.D2 + TOP.D3,2); 
     TOP.n1 = mod(TOP.n4 + TOP.In,2); 
     TOP.n2 = mod(TOP.D1 + TOP.n1,2); 
     TOP.n3 = mod(TOP.D3 + TOP.n2,2); 

     BOT.n4 = mod(BOT.D2 + BOT.D3,2); 
     BOT.n1 = mod(BOT.n4 + BOT.In,2); 
     BOT.n2 = mod(BOT.D1 + BOT.n1,2); 
     BOT.n3 = mod(BOT.D3 + BOT.n2,2); 
     

     out1(i,ii) = TOP.In; 
     out2(i,ii) = TOP.n3; 
     out3(i,ii) = BOT.n3; 
     
     
 
 end
 
    temp_OUT = [out1(i,:); out2(i,:) ;out3(i,:)];
    temp_OUT = temp_OUT(:);
 
 for iii = 1:3 
    % Update Registers 
     TOP.D3 = TOP.D2;
     TOP.D2 = TOP.D1;
     TOP.D1 = TOP.n1;
     TOP.In = Input(ii); 
 
     BOT.D3 = BOT.D2;
     BOT.D2 = BOT.D1;
     BOT.D1 = BOT.n1;
     BOT.In = Input_Interleaved(ii); 
 
     % Calculate
     TOP.n4 = mod(TOP.D2 + TOP.D3,2); 
     TOP.n1 = mod(TOP.n4,2); 
     TOP.n2 = mod(TOP.D1 + TOP.n1,2); 
     TOP.n3 = mod(TOP.D3 + TOP.n2,2); 
     

     BOT.n4 = mod(BOT.D2 + BOT.D3,2); 
     BOT.n1 = mod(BOT.n4,2); 
     BOT.n2 = mod(BOT.D1 + BOT.n1,2); 
     BOT.n3 = mod(BOT.D3 + BOT.n2,2); 
     

     x(i,iii)   = TOP.n1; 
     z(i,iii)   = TOP.n3; 
     z_p(i,iii) = BOT.n3; 
     x_p(i,iii) = BOT.n4; 
     
       
 end

    temp_OUT(K*3+1: K*3+12) = [x(1) z(1) x(2) z(2) x(3) z(3) x_p(1) z_p(1) x_p(2) z_p(2) x_p(3) z_p(3)];
 
    OUT(i,:) = temp_OUT; 
    
 ind = ind + K; 
end

%% Last Block
Input_end = data(ind:end); 
index2 = 1:length(Input_end); 
new_index2 = mod(f1.*index2 + f2.*index2.^2,length(index2))+1; 
Input_Interleaved_end = Input_end(new_index2);

K2 = length(new_index2); 
 
 for ii = 1:length(new_index2)
     
     % Update Registers 
     TOP.D3 = TOP.D2;
     TOP.D2 = TOP.D1;
     TOP.D1 = TOP.n1;
     TOP.In = Input_end(ii); 
 
     BOT.D3 = BOT.D2;
     BOT.D2 = BOT.D1;
     BOT.D1 = BOT.n1;
     BOT.In = Input_Interleaved_end(ii); 
     
     %Calculate 
     TOP.n1 = mod(TOP.n4 + TOP.In,2); 
     TOP.n2 = mod(TOP.D1 + TOP.n1,2); 
     TOP.n3 = mod(TOP.D3 + TOP.n2,2); 
     TOP.n4 = mod(TOP.D2 + TOP.D3,2); 

     BOT.n1 = mod(BOT.n4 + BOT.In,2); 
     BOT.n2 = mod(BOT.D1 + BOT.n1,2); 
     BOT.n3 = mod(BOT.D3 + BOT.n2,2); 
     BOT.n4 = mod(BOT.D2 + BOT.D3,2); 

     out1(i+1,ii) = TOP.In; 
     out2(i+1,ii) = TOP.n3; 
     out3(i+1,ii) = BOT.n3; 
     
     

 
 end
    temp_OUT = [out1(i+1,1:K2) out2(i+1,1:K2) out3(i+1,1:K2)].';
    temp_OUT = temp_OUT(:);
    
 for iii = 1:3 
     % Update Registers 
     TOP.D3 = TOP.D2;
     TOP.D2 = TOP.D1;
     TOP.D1 = TOP.n1;
     TOP.In = Input(ii); 
 
     BOT.D3 = BOT.D2;
     BOT.D2 = BOT.D1;
     BOT.D1 = BOT.n1;
     BOT.In = Input_Interleaved(ii); 
     
     % Calculate 
     TOP.n1 = mod(TOP.n4,2); 
     TOP.n2 = mod(TOP.D1 + TOP.n1,2); 
     TOP.n3 = mod(TOP.D3 + TOP.n2,2); 
     TOP.n4 = mod(TOP.D2 + TOP.D3,2); 

     BOT.n1 = mod(BOT.n4,2); 
     BOT.n2 = mod(BOT.D1 + BOT.n1,2); 
     BOT.n3 = mod(BOT.D3 + BOT.n2,2); 
     BOT.n4 = mod(BOT.D2 + BOT.D3,2); 

     x(i+1,iii)   = TOP.n1; 
     z(i+1,iii)   = TOP.n3; 
     z_p(i+1,iii) = BOT.n3; 
     x_p(i+1,iii) = BOT.n1; 
   
    
 end

  temp_OUT(K2*3+1: K2*3+12) = [x(1) z(1) x(2) z(2) x(3) z(3) x_p(1) z_p(1) x_p(2) z_p(2) x_p(3) z_p(3)];
  OUT(i+1,1:K2*3+12) = temp_OUT; 

%trunc_len = (K-length(new_index2))*3;
 
%OUT1 = [

%OUT = reshape([out1(:) out2(:) out3(:)].', K*(i+1)*3,1);
%OUT = OUT(1:end-trunc_len);
OUT = OUT.'; % Each Column is an output sub block.


