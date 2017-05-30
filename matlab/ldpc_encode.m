% Based on src/LdpcEncode.c from https://sourceforge.net/projects/dvbldpc/
% This seems to be the same thing that matlab uses internally. 
h = dvbs2ldpc(1/2);
[M, n] = size(h);
k = n - M;

data = logical(randi([0 1], k, 1));
parity_bits = false(M, 1);

% The last M columns of h are just a double diagonal matrix, not needed.
hTrunc = h(:, 1:k);

tmp_bit = false;
x = false(M, 1);

% There are a small constant number of nonzero indices per row.
nz_per_row = sum(hTrunc(1, :));

% nz_col_indices is an M x (small) matrix, each row of which specifies the
% indices of nonzero elements in the corresponding row of H.
[nz_cols, nz_rows] = find(hTrunc');
nz_indices = reshape(nz_cols,  nz_per_row, length(nz_cols) / nz_per_row)';

% Iterate over the rows of H, doing a constant amount of work in each
% iteration.
for i = 1:M
        
    % odd or even?
    x(i) = rem(sum(  data(nz_indices(i, :))), 2); 
    
    % why the extra xor bit?
    % https://en.wikipedia.org/wiki/Differential_coding
    parity_bits(i) = xor(x(i), tmp_bit);
    tmp_bit = parity_bits(i); 
end

codeword = cat(1, data, parity_bits);

% Check that it matches the builtin function.
hEnc = comm.LDPCEncoder(h);
codeword2 = step(hEnc, data);
isequal(codeword, codeword2)

