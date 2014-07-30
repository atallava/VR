classdef swingController < handle
    %swingController controller to rotate robot

    properties (Constant = true)
        MAX_SIZE = 1000;
    end
    properties (SetAccess = private)
        kp = 0.05;
        ki
        dThI
        tArray
        WPArray; WIArray;
        WArray
    end
    
    methods
        function obj = swingController(inputStruct)
            % inputStruct fields ('kp','ki')
            % default (0.2,0.05)
            if isfield(inputStruct,'kp')
                obj.kp = inputStruct.kp;
            else
            end
            if isfield(inputStruct,'ki')
                obj.ki = inputStruct.ki;
            else
            end
        end
        
        function [V,w] = computeControl(obj,t,refPose,currentPose)
            dTh = thDiff(refPose(3),currentPose(3));
            if length(obj.tArray) > 1
                dt = t-obj.tArray(end);
                obj.dThI = obj.dThI+dTh*dt;
            else
                obj.dThI = 0;
            end
            V = 0;
            w = obj.kp*dTh+obj.ki*obj.dThI;
            obj.tArray(end+1) = t;
            obj.WPArray(end+1) = obj.kp*dTh; obj.WIArray(end+1) = obj.ki*obj.dThI;
            obj.WArray(end+1) = w;
        end
        
        end

    methods (Static = true)
    end

end
