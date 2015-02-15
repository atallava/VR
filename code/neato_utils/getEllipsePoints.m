function [x,y] = getEllipsePoints(S)
%GETELLIPSEPOINTS Get error ellipse points from covariance.
% 
% [x,y] = GETELLIPSEPOINTS(S)
% 
% S - Input covariance. Only top left 2x2 retained.

S = S(1:2,1:2);
conf = 0.5;
[x,y,~] = errorEllipseGetPoints(S);
k = qchisq(conf,2);
x = k*x; y = k*y;

% sometimes points are imaginary
x = real(x); y = real(y);
end