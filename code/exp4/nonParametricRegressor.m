classdef nonParametricRegressor < handle & abstractRegressor
    %nonParametricRegressor simple class for nonparametric regression
    
    properties (SetAccess = private)
        % kernelFn is a function handle to some kernel
        % kernelParams is a struct that is input to kernelFn
        dimY
        kernelFn
        kernelParams
    end
    
    methods
        function obj = nonParametricRegressor(inputStruct)
            % inputStruct fields ('XTrain','YTrain','XSpaceSwitch','kernelFn','kernelParams')
            if nargin > 0
                obj.XTrain = inputStruct.XTrain;
                obj.YTrain = inputStruct.YTrain;
                if isfield(inputStruct,'XSpaceSwitch')
                   obj.XSpaceSwitch = inputStruct.XSpaceSwitch;
                   obj.removeSwitchedTrainingData();
                else
                    obj.XSpaceSwitch = [];
                end
                obj.kernelFn = inputStruct.kernelFn;
                obj.kernelParams = inputStruct.kernelParams;
                obj.dimY = size(obj.YTrain,2);    
            end
        end
        
        function Y = predict(obj,X)
            nQueries = size(X,1);
            Y = zeros(nQueries,obj.dimY);
            K = pdist2(obj.XTrain,X,@(x,y) obj.kernelFn(x,y,obj.kernelParams));
            
            % flu is a flag that waves when a point is far from the sphere
            % of influence of training data
            weightThresh = 0.1;
            maxWeights = max(K,[],1);
            flu = maxWeights <= weightThresh;
            
            for i = 1:obj.dimY
                % non-NaN entries
                validMask = ~isnan(obj.YTrain(:,i));
                y = obj.YTrain(:,i);
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
            
            if ~isempty(obj.XSpaceSwitch)
                flag = obj.XSpaceSwitch.switchX(X);
                Y(flag,:) = repmat(obj.XSpaceSwitch.switchY,sum(flag),1);
            end
            
            obj.XLast = X;
            obj.YLast = Y;
        end
    end
end

