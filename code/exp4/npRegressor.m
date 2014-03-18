function [Y,flu] = npRegressor(XTrain,YTrain,X,kernelName)
%npRegressor an implementation of a non parametric regressor
% Xtrain is observations x Xdimension
% Ytrain is observations x Ydimension
% X is queries x Xdimension
% Y is queries x Ydimension
% flu is an array of length queries. 1 is query is out of influence of
% XTrain, 0 otherwise

K = kernelMat(kernelName,XTrain,X);
nQueries = size(X,1);
dimY = size(YTrain,2);
Y = zeros(nQueries,dimY);

weightThresh = 0.1;
maxWeights = max(K,[],1);
flu = maxWeights <= weightThresh;

for i = 1:dimY
    % non-NaN entries
    validMask = ~isnan(YTrain(:,i));
    y = YTrain(:,i);
    for j = 1:nQueries
        weights = K(:,j).*validMask;
        weights = weights(validMask);
        if sum(weights) == 0
            Y(j,i) = 0;
            continue;
        else            
            Y(j,i) = sum(weights.*y(validMask))/sum(weights);
        end
    end
end
end

