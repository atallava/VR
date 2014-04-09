classdef locallyWeightedLinearRegressor < handle
    %locallyWeightedRegressor simple class for locally weighted linear regression
    
    properties (SetAccess = private)
        % XTrain is num observations x dimX, training input
        % YTrain is num observations x dimY, training output
        % kernelFn is a function handle to some kernel
        % kernelParams is a struct that is input to kernelFn
        % XLast is num queries x dimX, cache of last query
        % YLast is num queries x dimY, cache of last query
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

            % flu is a flag that waves when a point is far from the sphere
            % of influence of training data
            weightThresh = 0.1;
            maxWeights = max(K,[],1);
            flu = maxWeights <= weightThresh;
            
            tempX = [obj.XTrain ones(size(obj.XTrain,1),1)];
            for i = 1:nQueries
                weights = K(:,i);
                weights = weights/sum(weights);
                W = diag(weights);
                tempPoly = (tempX'*W*tempX)\(tempX'*W*obj.YTrain);
                tempPoly = flipud(tempPoly);
                for j = 1:obj.dimY
                    Y(i,j) = firstOrderPoly(tempPoly(:,j),X(i,:));
                end
            end
            obj.XLast = X;
            obj.YLast = Y;
        end
        
        function res = getMSE(obj)
            % return MSE on training data
            YTemp = predict(obj.XTrain);
            res = (YTemp-obj.YTrain).^2;
            res = sum(res,1)/size(obj.XTrain,1);
            res = sqrt(res);
        end
    end
    
end

