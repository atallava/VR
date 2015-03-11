function res = dRegress(XTrain,ZTrain,Z,X,bwX,bwZ)
% ZTrain is a cell array of length N.
% XTrain is N x 1
% Z is array of size R x 1
% X is array of size S x 1
% bwX, bwZ are respective kernel widths
% res is array of size S x R

N = size(XTrain,1);
R = length(Z);
S = length(X);

% some resizing
if isrow(Z)
    Z = Z';
end
if isrow(X)
    X = X';
end

p = zeros(R,N);
for i = 1:N
    % density estimates at Z|XTrain(i)
    p(:,i) = ksdensity(ZTrain{i},Z,'bandwidth',bwZ);
end

kernelParams.h = bwX;
K = pdist2(XTrain,X,@(x,y) kernelRBF(x,y,kernelParams));
% normalize each column of K
colSum = sum(K,1);
% K is N x S
K = bsxfun(@rdivide,K,colSum);

res = p*K;
res = res';
end

