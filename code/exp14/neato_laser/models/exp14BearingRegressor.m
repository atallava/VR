classdef exp14BearingRegressor < handle
    % Basically a LWL regressor, for each bearing.
    
    properties
        XTrain; YTrain
        XTrainBias
        % kernel is fixed
        kernelFn = @kernelRBF2; kernelParams
        maxTrainData = 300; minTrainData = 20;
        numTrainData
        insufficientData = false;
        nullPrediction = 0;
        debugFlag = false;
    end
    
    methods
        function obj = exp14BearingRegressor(inputStruct)
            % [N,2]
            obj.XTrain = inputStruct.XTrain;
            % [N,1]
            obj.YTrain = inputStruct.YTrain;
            obj.kernelParams = inputStruct.kernelParams;
            
            % throw away nan stuff
            ids1 = any(isnan(obj.XTrain),2);
            ids2 = isnan(obj.YTrain);
            ids = ids1 & ids2;
            obj.XTrain(ids,:) = [];
            obj.YTrain(ids,:) = [];
            
            % subsample if needed
            if length(obj.YTrain) > obj.maxTrainData
                ids = randsample(length(obj.YTrain),obj.maxTrainData);
                obj.XTrain = obj.XTrain(ids);
                obj.YTrain = obj.YTrain(ids,:);
            end
            obj.XTrainBias = [obj.XTrain ones(obj.numTrainData,1)];
            obj.numTrainData = length(obj.YTrain);
            
            % if insufficient data, raise alarm
            if obj.numTrainData <= obj.minTrainData
                obj.insufficientData = true;
                
                if obj.debugFlag
                    fprintf('exp14BearingRegressor:Insufficient data: %d.\n',obj.numTrainData);
                end
            end
                
        end
        
        function Y = predict(obj,X)
           nX = size(X,1);
           Y = zeros(nX,1);
           if obj.insufficientData
               Y = obj.nullReading*ones(nX,1);
               return;
           end
           
           K = pdist2(obj.XTrain,X,@(x,y) obj.kernelFn(x,y,obj.kernelParams)); % [nXTrain,nX]
           
           warning('off'); % prevent matrix inversion warnings
           % unfortunately this isn't parallelized
           for i = 1:nX
               W = diag(K(:,i));
               tempPoly = (obj.XTrainBias'*W*obj.XTrainBias)\(obj.XTrainBias'*W*obj.YTrain);
               Y(i) = dot(tempPoly,[X(i,:) 1]);
           end
           warning('on');
           
           if any(isnan(Y))
               error('exp14BearingRegressor:invalidPrediction','NaN predicted');
           end
        end
    end
    
end

