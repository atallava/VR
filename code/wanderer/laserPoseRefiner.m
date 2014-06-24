classdef laserPoseRefiner < handle
    %laserPoseRefiner refine pose by matching scans to a map
    % wrapper around exising functionality
    % fast but requires good initial pose estimate

    properties (SetAccess = private)
        localizer
        skip = 5
        numIterations = 40
        laser
    end

    methods
        function obj = laserPoseRefiner(inputData)
            % inputData fields ('localizer','skip','numIterations','laser')
            % default (,5,40,laserClass(struct()))
            if isfield(inputData,'localizer')
                obj.localizer = inputData.localizer;
            else
                error('LOCALIZER NOT INPUT.');
            end
            if isfield(inputData,'skip')
                obj.skip = inputData.skip;
            else
            end
            if isfield(inputData,'numIterations')
                obj.numIterations = inputData.numIterations;
            else
            end
            if isfield(inputData,'laser')
                obj.laser = inputData.laser;
            else
                obj.laser = laserClass(struct());
            end
        end
        
        function [success,poseOut] = refine(obj,ranges,poseIn)
            if ~isa(poseIn,'pose2D')
                poseIn = pose2D(poseIn);
            end 
            laserPoseIn = obj.laser.refPoseToLaserPose(poseIn);
            ri = rangeImage(struct('ranges',ranges,'cleanup',1));
            ptsLocal = ri.getPtsHomogeneous();
            ptsLocal = ptsLocal(:,1:obj.skip:end);
            outIds = obj.localizer.throwOutliers(ptsLocal,laserPoseIn);
            ptsLocal(:,outIds) = [];
            [success, laserPoseOut] = obj.localizer.refinePose(laserPoseIn,ptsLocal,20);
            poseOut = pose2D.transformToPose(laserPoseOut.T/(obj.laser.Tsensor));
        end
    end

    methods (Static = true)
    end

end
