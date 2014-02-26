function K = kernelMat(kernelName,X,Y)
% generate matrix of kernel responses
% X is a m x d array, Y is a n x d array
% output is a matrix of size m x n

m = size(X,1);
n = size(Y,1);
K = zeros(m,n);

for i = 1:m
    for j = 1:n
        K(i,j) = feval(kernelName,X(i,:),Y(j,:));
    end
end

end

