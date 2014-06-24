classdef laserClass < handle
    %laserClass sensor information
    
    properties (SetAccess = private)
        % distance unit: m
        % angle unit: rad
        maxRange
        rangeRes
        bearings
        nPixels
        nullReading
        Tsensor % describes sensor frame wrt some other frame, typically robot origin
    end
    
    methods
        function obj = laserClass(inputData)
            % inputData fields ('maxRange','rangeRes','bearings','nullReading','Tsensor')
            % default (4.5, 0.001, deg2rad(0:359), 0, eye(3))
            if isfield(inputData,'maxRange')
                obj.maxRange = inputData.maxRange;
            else
                obj.maxRange = 4.5;
            end
            if isfield(inputData,'rangeRes')
                obj.rangeRes = inputData.rangeRes;
            else
                obj.rangeRes = 0.001;
            end
            if isfield(inputData,'bearings')
                obj.bearings = inputData.bearings;
            else
                obj.bearings = deg2rad(0:359);
            end
            if isfield(inputData,'Tsensor')
                obj.Tsensor = inputData.Tsensor;
            else
                obj.Tsensor = eye(3);
            end
            obj.nPixels = length(obj.bearings);
            if isfield(inputData,'nullReading')
                obj.nullReading = inputData.nullReading;
            else
                obj.nullReading = 0;
            end
        end
        
        function laserPose = refPoseToLaserPose(obj,refPose)
           % given reference pose, return laser pose
           laserPose = pose2D.pose1ToPose2(refPose,obj.Tsensor);
        end
        
        function refPose = laserPoseToRefPose(obj,laserPose)
            % given laser pose, return reference pose
            refPose = pose2D.pose1ToPose2(laserPose,inv(obj.Tsensor));
        end
    end
end

