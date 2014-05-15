classdef dataProcessor < handle
    %dataProcessor class to initialize data before prediction
        
    properties (SetAccess = private)
        % poses is 3 x total poses
        % obsArray is a cell array of size total poses x num pixels
        % pixelIds are pixelIds in the original stuff
        % bearings are in rad
        % maxRange of sensor in m
        % trainPoseIds are the poses to train over
        % testPoseIds are the poses to test at
        % XTrain is num train poses x 3
        % XTest is num test poses x 3
        poses
        obsArray
        pixelIds
        nPixels
        bearings
        maxRange
        trainPoseIds
        testPoseIds        
        XTrain
        XTest    
    end
    
    methods
        function obj = dataProcessor(inputData)
            % inputData fields
            % ('poses','obsArray','pixelIds','bearings','maxRange','trainPoseIds','testPoseIds')
            obj.poses = inputData.poses;
            obj.obsArray = inputData.obsArray;
            obj.pixelIds = inputData.pixelIds;
            obj.nPixels = length(obj.pixelIds);
            obj.bearings = inputData.bearings; 
            obj.maxRange = inputData.maxRange;
            obj.trainPoseIds = inputData.trainPoseIds;
            obj.testPoseIds = inputData.testPoseIds;
            
            obj.XTrain = obj.poses';
            obj.XTrain = obj.XTrain(obj.trainPoseIds,:);
            obj.XTest = obj.poses';
            obj.XTest = obj.XTest(obj.testPoseIds,:);
        end
    end
    
end

