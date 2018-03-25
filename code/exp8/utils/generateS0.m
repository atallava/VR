function S0 = generateS0(posnErr,thErr)
%GENERATES0 Generate initial covariance.
% 
% S0 = GENERATES0(posnErr,thErr)
% 
% posnErr - In m.
% thErr   - In rad.
% 
% S0      - 3x3 diagonal.

S0 = diag([(posnErr/3)^2 (posnErr/3)^2 (thErr/3)^2]);
end

