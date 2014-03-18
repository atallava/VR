function res = kernelBox(x1,x2)
% box kernel centered about x1
% x1 and x2 are vectors of the same dimension

res = 0;

% an important parameter, currently fixed
lengthScale = 2.0; 
if norm(x1-x2) <= lengthScale/2
    res = 1;
end
end

