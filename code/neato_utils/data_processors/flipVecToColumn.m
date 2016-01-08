function [vec,inputColumn] = flipVecToColumn(vec)
%FLIPVECTOCOLUMN 
% 
% [vec,inputColumn] = FLIPVECTOCOLUMN(vec)
% 
% vec         - 
% 
% vec         - 
% inputColumn - 

[vec,inputRow] = flipVecToRow(vec);
vec = vec';
inputColumn = ~inputRow;
end