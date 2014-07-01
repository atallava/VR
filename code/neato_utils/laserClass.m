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
        function obj = laserClass(inputStruct)
            % inputStruct fields ('maxRange','rangeRes','bearings','nullReading','Tsensor')
            % default (4.5, 0.001, deg2rad(0:359), 0, eye(3))
            if isfield(inputStruct,'maxRange')
                obj.maxRange = inputStruct.maxRange;
            else
                obj.maxRange = 4.5;
            end
            if isfield(inputStruct,'rangeRes')
                obj.rangeRes = inputStruct.rangeRes;
            else
                obj.rangeRes = 0.001;
            end
            if isfield(inputStruct,'bearings')
                obj.bearings = inputStruct.bearings;
            else
                obj.bearings = deg2rad(0:359);
            end
            if isfield(inputStruct,'Tsensor')
                obj.Tsensor = inputStruct.Tsensor;
            else
                obj.Tsensor = eye(3);
            end
            obj.nPixels = length(obj.bearings);
            if isfield(inputStruct,'nullReading')
                obj.nullReading = inputStruct.nullReading;
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

