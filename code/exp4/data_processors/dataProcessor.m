classdef dataProcessor < handle
    %dataProcessor class to initialize data before prediction
        
    properties (SetAccess = private)
        % poses is 3 x total poses
        % obsArray is a cell array of size total poses x num pixels
        % laser is a laserClass object
        % trainPoseIds are the poses to train over
        % testPoseIds are the poses to test at
        % XTrain is num train poses x 3
        % XTest is num test poses x 3
        poses
        obsArray
        laser
        trainPoseIds
        testPoseIds        
        XTrain
        XTest    
    end
    
    methods
        function obj = dataProcessor(inputStruct)
            % inputStruct fields
            % ('poses','obsArray','laser','trainPoseIds','testPoseIds')
            obj.poses = inputStruct.poses;
            obj.obsArray = inputStruct.obsArray;
            obj.laser = inputStruct.laser;
            obj.trainPoseIds = inputStruct.trainPoseIds;
            obj.testPoseIds = inputStruct.testPoseIds;
            
            obj.XTrain = obj.poses';
            obj.XTrain = obj.XTrain(obj.trainPoseIds,:);
            obj.XTest = obj.poses';
            obj.XTest = obj.XTest(obj.testPoseIds,:);
        end
    end
    
end

