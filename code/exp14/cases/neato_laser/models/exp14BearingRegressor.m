classdef exp14BearingRegressor < handle
    % Basically a LWL regressor, for each bearing.
    
    properties
        X; Y
        XBias
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
            obj.X = inputStruct.X;
            % [N,1]
            obj.Y = inputStruct.Y;
            obj.kernelParams = inputStruct.kernelParams;
            
            % throw away nan stuff
            ids1 = any(isnan(obj.X),2);
            ids2 = isnan(obj.Y);
            ids = ids1 | ids2;
            obj.X(ids,:) = [];
            obj.Y(ids,:) = [];
            
            % subsample if needed
            if length(obj.Y) > obj.maxTrainData
                ids = randsample(length(obj.Y),obj.maxTrainData);
                obj.X = obj.X(ids);
                obj.Y = obj.Y(ids,:);
            end
            obj.numTrainData = length(obj.Y);
            obj.XBias = [obj.X ones(obj.numTrainData,1)];
                        
            % if insufficient data, raise alarm
            if obj.numTrainData <= obj.minTrainData
                obj.insufficientData = true;
                
                if obj.debugFlag
                    fprintf('exp14BearingRegressor:Insufficient data: %d.\n',obj.numTrainData);
                end
            end
                
        end
        
        function YQuery = predict(obj,XQuery)
           nQuery = size(XQuery,1);
           YQuery = zeros(nQuery,1);
           if obj.insufficientData
               YQuery = obj.nullPrediction*ones(nQuery,1);
               return;
           end
           
           K = pdist2(obj.X,XQuery,@(x,y) obj.kernelFn(x,y,obj.kernelParams)); % [nX,nX]
           
           warning('off'); % prevent matrix inversion warnings
           % unfortunately this isn't parallelized
           for i = 1:nQuery
               W = diag(K(:,i));
               tempPoly = (obj.XBias'*W*obj.XBias)\(obj.XBias'*W*obj.Y);
               % matrix inversion failure
               if any(isnan(tempPoly)) | any(isinf(tempPoly))
                   YQuery(i) = obj.nullPrediction;
                   continue;
               end
               YQuery(i) = dot(tempPoly,[XQuery(i,:) 1]);
           end
           warning('on');
           
           % deal with nan XQuery
           ids = any(isnan(XQuery),2);
           YQuery(ids) = obj.nullPrediction;
           
           % deal with negative predictions
           YQuery(YQuery < 0) = obj.nullPrediction;
           
           if any(isnan(YQuery))
               error('exp14BearingRegressor:invalidPrediction','NaN predicted');
           end
        end
    end
    
end

