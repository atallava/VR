classdef exp14LaserModel < handle
    % a laser model that does deterministic prediction of range data
    % building off most of exp4 code
    
    properties
        XTrain; YTrain
        maxTrainData = 300;
        numTrainData
        maxClearReading = 5.0; % in m. all distances in m
        minClearReading = 0.081;
        bearings = deg2rad(0:359);
        numBearings = 360;
        rArrayTrain; alphaArrayTrain;
        bearingRegressors;
        kernelParams;
        debugFlag = false;
    end
    
    methods
        function obj = exp14LaserModel(inputStruct)
            % inputStruct fields ('XTrain','YTrain','kernelParams')
            % XTrain is a struct array with fields ('sensorPose','map')
            obj.XTrain = inputStruct.XTrain; 
            % YTrain is [length(XTrain),360]. Range readings
            obj.YTrain = inputStruct.YTrain;
            % RBF kernel is fixed
            obj.kernelParams = inputStruct.kernelParams;
            
            % treat range readings
            obj.YTrain(obj.YTrain > obj.maxClearReading) = obj.maxClearReading;
            obj.YTrain(obj.YTrain < obj.minClearReading) = obj.minClearReading;
            
            % subsample, if needed
            numTrainDataPre = length(obj.XTrain);
            % regressor can't handle too many data points
            if numTrainDataPre > obj.maxTrainData
                ids = randsample(numTrainDataPre,obj.maxTrainData);
                obj.XTrain = obj.XTrain(ids);
                obj.YTrain = obj.YTrain(ids,:);
            end
            obj.numTrainData = length(obj.XTrain);
            
            % generate data for each bearing
            [obj.rArrayTrain, obj.alphaArrayTrain] = deal(zeros(obj.numTrainData,obj.numBearings));
            for i = 1:obj.numTrainData
                [obj.rArrayTrain(i,:),obj.alphaArrayTrain(i,:)] = ...
                    obj.XTrain(i).map.raycast(obj.XTrain(i).sensorPose,obj.maxClearReading,obj.bearings);
            end
            
            % create regressor instance for each bearing
            obj.bearingRegressors = cell(obj.numBearings);
            inpStr.kernelParams = obj.kernelParams;
            for i = 1:obj.numBearings
                inpStr.XTrain = [obj.rArrayTrain(:,i) obj.alphaArrayTrain(:,i)];
                inpStr.YTrain = obj.YTrain(:,i);
                obj.bearingRegressors{i} = exp14BearingRegressor(inpStr);
            end
        end
        
        function updateKernelParams(obj,params)
            % only update the kernel params in the bearing regressors
            obj.kernelParams = params;
            for i = 1:obj.numBearings
                obj.bearingRegressors{i}.kernelParams = obj.kernelParams;
            end
        end
        
        function y = predict(obj,x)
            nX = length(x);
            y = zeros(nX,obj.numBearings);
            [rArray,alphaArray] = deal(zeros(nX,obj.numBearings));
            % collect r, alpha for each x
            for i = 1:nX
                [rArray(i,:),alphaArray(i,:)] = x.map.raycast(x.sensorPose,obj.maxClearReading,obj.bearings);
            end
            
            % loop predictions over bearings
            for i = 1:obj.numBearings
                x_i = [rArray(:,i) alphaArray(:,i)];
                y(:,i) = obj.bearingRegressors{i}.predict(x_i);
            end
            
        end
    end
    
end

