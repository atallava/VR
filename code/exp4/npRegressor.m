function Y = npRegressor(XTrain,YTrain,X,kernelName)
%npRegressor an implementation of a non parametric regressor
% Xtrain is observations x Xdimension
% Ytrain is observations x Ydimension
% X is queries x Xdimension
% Y is queries x Ydimension

K = kernelMat(kernelName,XTrain,X);
nQueries = size(X,1);
dimY = size(YTrain,2);
Y = zeros(nQueries,dimY);

for i = 1:nQueries
    weights = K(:,i);
    weightedSum = bsxfun(@times,YTrain,weights);
    if sum(weights) ~= 0
        weightedSum = sum(weightedSum)/sum(weights);
    else
        weightedSum = zeros(1,dimY);
    end
    Y(i,:) = weightedSum;
end

end

