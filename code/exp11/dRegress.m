function res = dRegress(XTrain,ZTrain,X,hX,hZ)
% ZTrain is a matrix of size N x M.
% XTrain is N x 1
% X is scalar

N = size(XTrain,1);
p = zeros(N,1);
for i = 1:N
    p(i) = ksdensity(ZTrain(i,:),X,'bandwidth',hZ);
end

kernelParams.h = hX;
K = pdist2(XTrain,X,@(x,y) kernelRBF(x,y,kernelParams));
res = p.*K/sum(K);
end

