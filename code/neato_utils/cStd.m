function res = cStd(stdArray,n)
%CSTD Combine std from multiple samples.
% 
% res = CSTD(stdArray,n)
% 
% stdArray - Array of length m.
% n        - Number of samples used to compute each element of stdArray.
% 
% res      - std from all samples.

m = length(stdArray);
res = sum(stdArray.^2);
res = (n-1)*res/(m*n-1);
res = sqrt(res);
end