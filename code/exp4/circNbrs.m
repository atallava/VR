function [l,r] = circNbrs(i,n)
if i == 1
    l = n;
else 
    l = i-1;
end
if i == n
    r = 1;
else
    r = i+1;
end
end

