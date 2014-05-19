classdef locallyWeightedLinearRegressor < handle & abstractRegressor
    %locallyWeightedRegressor simple class for locally weighted linear regression
    
    properties (SetAccess = private)
        % kernelFn is a function handle to some kernel
        % kernelParams is a struct that is input to kernelFn
        XTrain
        YTrain
        dimY
        kernelFn
        kernelParams
        XLast
        YLast
    end
    
    methods
        function obj = locallyWeightedLinearRegressor(inputData)
            % inputData fields ('XTrain','YTrain','kernelFn','kernelParams')
            if nargin > 0
                obj.XTrain = inputData.XTrain;
                obj.YTrain = inputData.YTrain;
                obj.kernelFn = inputData.kernelFn;
                obj.kernelParams = inputData.kernelParams;
                obj.dimY = size(obj.YTrain,2);
            end
        end
        
        function Y = predict(obj,X)
            K = pdist2(obj.XTrain,X,@(x,y) obj.kernelFn(x,y,obj.kernelParams));
            nQueries = size(X,1);
            Y = zeros(nQueries,obj.dimY);

            tempX = [obj.XTrain ones(size(obj.XTrain,1),1)];
            for i = 1:nQueries
                weights = K(:,i);
                for j = 1:obj.dimY
                    validIds = ~isnan(obj.YTrain(:,j));
                    if sum(validIds) == 0
                        Y(i,j) = nan;
                        continue;
                    else
                        validY = obj.YTrain(validIds,j);
                        validWts = weights(validIds);
                        validWts = validWts/sum(validWts);
                        validX = tempX(validIds,:);
                        W = diag(validWts);
                        tempPoly = (validX'*W*validX)\(validX'*W*validY);
                        tempPoly = flipud(tempPoly)';
                        Y(i,j) = firstOrderPoly(tempPoly,X(i,:));
                    end
                end
            end
            obj.XLast = X;
            obj.YLast = Y;
        end
    end
    
end

