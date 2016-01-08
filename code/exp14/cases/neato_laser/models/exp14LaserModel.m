classdef exp14LaserModel < handle
    % a laser model that does deterministic prediction of range data
    % building off most of exp4 code
    
    properties
        X; Y
        rangesArray
        laser
        maxTrainData = 300;
        numTrainData
        maxClearReading = 5.0; % in m. all distances in m
        minClearReading = 0.081;
        rArrayTrain; alphaArrayTrain;
        bearingRegressors;
        kernelParams;
        XQueryLast; YQueryLast;
        debugFlag = false;
    end
    
    methods
        function obj = exp14LaserModel(inputStruct)
            % inputStruct fields ('X','Y','laser','kernelParams')
            % X is a struct array with fields ('sensorPose','map')
            if isfield(inputStruct,'X')
                obj.X = inputStruct.X;
            else
                error('exp14LaserModel:constructor','X not input');
            end
            % Y is a struct array with fields ('ranges')
            if isfield(inputStruct,'Y')
                obj.Y = inputStruct.Y;
            else
                error('exp14LaserModel:constructor','Y not input');
            end
            
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = laserClass(struct());
            end
            
            % extract rangesArray from obj.Y
            obj.rangesArray = [obj.Y.ranges];
            obj.rangesArray = reshape(obj.rangesArray,obj.laser.nBearings,length(obj.Y))';
                        
            % RBF kernel, fixed
            obj.kernelParams = inputStruct.kernelParams;
            
            % treat range readings
            obj.rangesArray(obj.rangesArray > obj.maxClearReading) = obj.maxClearReading;
%             obj.rangesArray(obj.rangesArray < obj.minClearReading) = obj.laser.nullReading;
            obj.rangesArray(obj.rangesArray < obj.minClearReading) = nan; % TODO: this is a hack
            
            % subsample, if needed
            numTrainDataPre = length(obj.X);
            % regressor can't handle too many data points
            if numTrainDataPre > obj.maxTrainData
                ids = randsample(numTrainDataPre,obj.maxTrainData);
                obj.X = obj.X(ids);
                obj.rangesArray = obj.rangesArray(ids,:);
            end
            obj.numTrainData = length(obj.X);
            
            % generate data for each bearing
            [obj.rArrayTrain, obj.alphaArrayTrain] = deal(zeros(obj.numTrainData,obj.laser.nBearings));
            for i = 1:obj.numTrainData
                [obj.rArrayTrain(i,:),obj.alphaArrayTrain(i,:)] = ...
                    obj.X(i).map.raycast(obj.X(i).sensorPose,obj.maxClearReading,obj.laser.bearings);
            end
            
            % create regressor instance for each bearing
            obj.bearingRegressors = cell(1,obj.laser.nBearings);
            inpStr.kernelParams = obj.kernelParams;
            for i = 1:obj.laser.nBearings
                inpStr.X = [obj.rArrayTrain(:,i) obj.alphaArrayTrain(:,i)];
                inpStr.Y = obj.rangesArray(:,i);
                obj.bearingRegressors{i} = exp14BearingRegressor(inpStr);
            end
        end
        
        function updateModelParams(obj,params)
            if isstruct(params)
                obj.updateKernelParams(params);
            elseif isVec(params)
                obj.updateKernelParams(struct('h',params));
            else
                error('thrunLaserModel:updateModelParams:invalidParams',...
                    'params must be struct or vector.');
            end
        end
        
        function updateKernelParams(obj,kernelParams)
            % only update the kernel params in the bearing regressors
            obj.kernelParams = kernelParams;
            for i = 1:obj.laser.nBearings
                obj.bearingRegressors{i}.kernelParams = obj.kernelParams;
            end
        end
        
        function YQuery = predict(obj,XQuery)
            %PREDICT
            %
            % YQuery = PREDICT(obj,XQuery)
            %
            % XQuery - Struct array with fields ('sensorPose','map')
            %
            % YQuery - Struct array with fields ('ranges')
            
            clockLocal = tic();
            nQuery = length(XQuery);
            rangesQuery = zeros(nQuery,obj.laser.nBearings);
            [rArray,alphaArray] = deal(zeros(nQuery,obj.laser.nBearings));
            % collect r, alpha for each x
            for i = 1:nQuery
                map = XQuery(i).map;
                sensorPose = XQuery(i).sensorPose;
                [rArray(i,:),alphaArray(i,:)] = map.raycast(sensorPose,obj.maxClearReading,obj.laser.bearings);
            end
            
            % loop predictions over bearings
            for i = 1:obj.laser.nBearings
                rAlphaQuery_i = [rArray(:,i) alphaArray(:,i)];
                rangesQuery(:,i) = obj.bearingRegressors{i}.predict(rAlphaQuery_i);
            end
            
            YQuery = struct('ranges',mat2cell(rangesQuery,ones(1,nQuery),obj.laser.nBearings)');
            
            obj.XQueryLast = XQuery;
            obj.YQueryLast = YQuery;
            tComp = toc(clockLocal);
            if obj.debugFlag
                fprintf('exp14LaserModel:Computation time: %.2fs.\n',tComp);
            end
        end
    end
    
end

