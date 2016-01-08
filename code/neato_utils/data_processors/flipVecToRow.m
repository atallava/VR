function [vec,inputRow] = flipVecToRow(vec)
%FLIPVECTOROW 
% 
% [vec,inputRow] = FLIPVECTOROW(vec)
% 
% vec      - Vector.
% 
% vec      - Row vector.
% inputRow - 1 if input was row, 0 otherwise.

if isrow(vec)
    inputRow = 1;
elseif iscolumn(vec)
    vec = vec';
    inputRow = 0;
else
    error('flipVecToRow:invalidData','Input must be row or column.');
end
end