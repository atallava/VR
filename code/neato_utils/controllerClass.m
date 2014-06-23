classdef controllerClass < handle
    %controller proportional gains on distance and heading error

    properties (Constant = true)
        MAX_SIZE = 1000;
    end
    properties (SetAccess = private)
        gainV
        gainW
        tArray
        VArray
        WArray
    end
    
    methods
        function obj = controllerClass(inputData)
            % inputData fields ('gainV','gainW')
            % default (0.2,0.05)
            if isfield(inputData,'gainV')
                obj.gainV = inputData.gainV;
            else
                obj.gainV = 0.2;
            end
            if isfield(inputData,'gainW')
                obj.gainW = inputData.gainW;
            else
                obj.gainW = 0.05;
            end
        end
        
        function [V,w] = computeControl(obj,t,refPose,currentPose)
            if ~isa(refPose,'pose2D')
                refPose = pose2D(refPose);
            end
            if ~isa(currentPose,'pose2D')
                currentPose = pose2D(currentPose);
            end
            [s_err,psi_err] = controllerClass.computePoseError(refPose,currentPose);
            V = obj.gainV*s_err;
            w = obj.gainW*psi_err;
            obj.tArray(end+1) = t;
            obj.VArray(end+1) = V;
            obj.WArray(end+1) = w;
        end
    end

    methods (Static = true)
        function [s_err,psi_err] = computePoseError(refPose,pose) %#ok<*INUSL>
            % refPose and pose are pose2D objects
            err = pose.Tb2w\[refPose.x; refPose.y; 1];
            s_err = norm(err(1:2));
            psi_err = atan2(err(2),err(1));
            if abs(psi_err) > pi/2
                s_err = -s_err;
                psi_err = -sign(psi_err)*pi+psi_err;
            end
        end
    end

end
