classdef laserPoseRefiner < handle
    %laserPoseRefiner refine pose by matching scans to a map
    % wrapper around exising functionality
    % fast but requires good initial pose estimate

    properties (SetAccess = private)
        localizer
        skip = 5
        numIterations = 40
        laser
        lastMatchDuration = []
        lastNumOutliers = []
    end

    methods
        function obj = laserPoseRefiner(inputStruct)
            % inputStruct fields ('localizer','skip','numIterations','laser')
            % default (,5,40,laserClass(struct()))
            if isfield(inputStruct,'localizer')
                obj.localizer = inputStruct.localizer;
            else
                error('LOCALIZER NOT INPUT.');
            end
            if isfield(inputStruct,'skip')
                obj.skip = inputStruct.skip;
            else
            end
            if isfield(inputStruct,'numIterations')
                obj.numIterations = inputStruct.numIterations;
            else
            end
            if isfield(inputStruct,'laser')
                obj.laser = inputStruct.laser;
            else
                obj.laser = laserClass(struct());
            end
        end
        
        function [success,poseOut] = refine(obj,ranges,poseIn)
            %REFINE Refine pose estimate.
            % Transforms pose laser frame, cleans up ranges, throws
            % outliers and matches scans.
            %
            % [success,poseOut] = REFINE(obj,ranges,poseIn)
            %
            % ranges  - Range array.
            % poseIn  - pose2D object or length 3 array. Reference pose.
            % success - struct.
            % poseOut - Refined pose of same format as poseIn.
            
            t1 = tic();
            objInput = isa(poseIn,'pose2D');
            if ~objInput
                poseIn = pose2D(poseIn);
            end 
            laserPoseIn = obj.laser.refPoseToLaserPose(poseIn);
            ri = rangeImage(struct('ranges',ranges,'bearings',obj.laser.bearings,'cleanup',1));
            ptsLocal = ri.getPtsHomogeneous();
            ptsLocal = ptsLocal(:,1:obj.skip:end);
            outIds = obj.localizer.throwOutliers(ptsLocal,laserPoseIn);
            obj.lastNumOutliers = sum(outIds);
            ptsLocal(:,outIds) = [];
            if isempty(ptsLocal)
                warning('NO INLIERS LEFT.');
            end
            [success, laserPoseOut] = obj.localizer.refinePose(laserPoseIn,ptsLocal,obj.numIterations);
            poseOut = pose2D.transformToPose(laserPoseOut.T/(obj.laser.Tsensor));
            if objInput
                poseOut = pose2D(poseOut);
            end
            obj.lastMatchDuration = toc(t1);
        end
        
        function setSkip(obj,skip)
            obj.skip = skip;
        end
        
        function setNumIterations(obj,numIterations)
            obj.numIterations = numIterations;
        end
        
    end

    methods (Static = true)
    end

end
