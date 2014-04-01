classdef dataProcessor < handle
    %dataProcessor class to initialize data before prediction
        
    properties
        % poses is 3 x total poses
        % obsArray is a cell array of size total poses x num pixels
        % rHist is an object of class rangeHistograms
        % trainPoseIds are the poses to train over
        % testPoseIds are the poses to test at
        % XTrain is num train poses x 3
        % XTest is num test poses x 3
        poses
        obsArray
        rHist 
        trainPoseIds
        testPoseIds        
        XTrain
        XTest
        pixelIds
    end
    
    methods
        function obj = dataProcessor(inputData)
            % inputData fields
            % ('poses','obsArray','rHist','trainPoseIds','testPoseIds')
            obj.poses = inputData.poses;
            obj.obsArray = inputData.obsArray;
            obj.rHist = inputData.rHist;
            obj.trainPoseIds = inputData.trainPoseIds;
            obj.testPoseIds = inputData.testPoseIds;
            
            obj.XTrain = obj.poses';
            obj.XTrain = obj.XTrain(obj.trainPoseIds,:);
            obj.XTest = obj.poses';
            obj.XTest = obj.XTest(obj.testPoseIds,:);
            obj.pixelIds = obj.rHist.pixelIds;
        end
    end
    
end

