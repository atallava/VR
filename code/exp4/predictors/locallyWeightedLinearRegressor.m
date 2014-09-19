classdef locallyWeightedLinearRegressor < handle & abstractRegressor
    %locallyWeightedRegressor simple class for locally weighted linear regression
    
    properties (SetAccess = private)
        % kernelFn is a function handle to some kernel
        % kernelParams is a struct that is input to kernelFn
        dimY
        kernelFn
        kernelParams
        hasScale = false
        scaleVec = []
    end
    
    methods
        function obj = locallyWeightedLinearRegressor(inputStruct)
            % inputStruct fields ('XTrain','YTrain','XSpaceSwitch','kernelFn','kernelParams')
            if nargin > 0
                obj.XTrain = inputStruct.XTrain;
                obj.YTrain = inputStruct.YTrain;
                obj.cleanTrainingData();
                if isfield(inputStruct,'XSpaceSwitch')
                   obj.XSpaceSwitch = inputStruct.XSpaceSwitch;
                   obj.removeSwitchedTrainingData();
                else
                    obj.XSpaceSwitch = [];
                end
                obj.kernelFn = inputStruct.kernelFn;
                obj.kernelParams = inputStruct.kernelParams;
                if isfield(obj.kernelParams,'lambda')
                    obj.hasScale = true;
                    obj.scaleVec = sqrt(obj.kernelParams.lambda);
                    if iscolumn(obj.scaleVec)
                        obj.scaleVec = obj.scaleVec';
                    end
                    obj.scaleVec = [1 obj.scaleVec];
                end
                obj.dimY = size(obj.YTrain,2);
            end
        end
        
        function Y = predict(obj,X)
            K = pdist2(obj.XTrain,X,@(x,y) obj.kernelFn(x,y,obj.kernelParams));
            nQueries = size(X,1);
            Y = zeros(nQueries,obj.dimY);
			
			if ~isempty(obj.XSpaceSwitch)
                switchFlag = obj.XSpaceSwitch.switchX(X);
			else
				switchFlag = [];
			end
            obj.XLast = X;
			
			tempX = [obj.XTrain ones(size(obj.XTrain,1),1)];
            if obj.hasScale
                X = obj.scaleXByLambda(X);
                tempX = bsxfun(@times,tempX,[obj.scaleVec 1]);
            end
            
            warning('off');
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
                        %tempPoly = flipud(tempPoly)'
                        Y(i,j) = firstOrderPoly(tempPoly,X(i,:));
                    end
                end
            end
            warning('on');
            if ~isempty(obj.XSpaceSwitch)
                Y(switchFlag,:) = repmat(obj.XSpaceSwitch.switchY,sum(switchFlag),1);
            end
			obj.YLast = Y;
        end
        
        function X = scaleXByLambda(obj,X)
            % X is numX x dimX
            X = bsxfun(@times,X,obj.scaleVec);
        end
    end
    
end

