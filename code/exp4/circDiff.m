function res = circDiff(a,b,n)
% b-a when these values wrap around n

if a <= b
    res = b-a;
else
    res = b+n-a;
end
end

