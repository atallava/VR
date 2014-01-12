function poly = fitLSPoly(x,y,n)
%data has values y at n 
%fit a polynomial of degree n in a least squares sense. return coefficients
%as a column vector

%preprocessing
if isrow(x)
    x = x';
end
if isrow(y)
    y = y';
end

cols = arrayfun(@(i) x.^i, 0:1:n, 'uni', 0);
A = cat(2,cols{:});
poly = (A'*A)\(A'*y);
poly = fliplr(poly); %matlab orders coefficients highest-to-lowest, left-to-right

end

