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
        
        function [success,poseOut] = refine(obj,ranges,poseIn,d)
            % [success,poseOut] = REFINE(obj,ranges,poseIn)
            % ranges  - Range array.
            % poseIn  - pose2D object or length 3 array.
            % success - struct.
            % poseOut - Refined pose of same format as poseIn.
            
            objInput = isa(poseIn,'pose2D');
            if ~objInput
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
            if objInput
                poseOut = pose2D(poseOut);
            end
            hf = obj.localizer.drawLines();
            hf = plotScan(pose2D(poseOut),ptsLocal,hf);
            xlim([-2 2]); ylim([-2 2]);
            set(hf,'visible','off');
            print('-dpng','-r72',sprintf('images/refiner_1/%d.png',d));
            close(hf);
        end
    end

    methods (Static = true)
    end

end
