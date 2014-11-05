classdef stitchedSpirals < abstractTrajectory
    
    
    properties
        spiralArray
        nSpirals
        startPose; finalPose
        tArray; poseArray;
        VArray; wArray;
    end
    
    methods
        function obj = stitchedSpirals(spiralArray)
            % spirals - Array of cubicSpiral objects.
            obj.spiralArray = spiralArray;
            obj.nSpirals = length(spiralArray);
            obj.startPose = obj.spiralArray(1).startPose;
            obj.finalPose = obj.spiralArray(end).finalPose;
            
            for i = 1:obj.nSpirals
                if i == 1
                    obj.tArray = obj.spiralArray(i).tArray;
                    obj.poseArray = obj.spiralArray(i).poseArray;
                    obj.VArray = obj.spiralArray(i).VArray;
                    obj.wArray = obj.spiralArray(i).wArray;
                else
                    vec = obj.spiralArray(i).tArray(2:end)+obj.tArray(end);
                    obj.tArray = [obj.tArray vec];
                    if ~isequal(obj.poseArray(:,end),obj.spiralArray(i).poseArray(:,1))
                        warning('Paths %d and %d do not line up',i-1,i);
                    end
                    obj.poseArray = [obj.poseArray obj.spiralArray(i).poseArray(:,2:end)];
                    obj.VArray = [obj.VArray obj.spiralArray(i).VArray(:,2:end)]; 
                    obj.wArray = [obj.wArray obj.spiralArray(i).wArray(:,2:end)]; 
                end
            end
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tArray(end)+2*obj.tIdle;
        end
        
        function res = getPoseAtTime(obj,t)
            if t < obj.tIdle
                res = obj.startPose;
            elseif t > obj.tArray(end)+obj.tIdle
                res = obj.finalPose;
            else
                t = t-obj.tIdle;
                res = interp1(obj.tArray,obj.poseArray',t);
                res = res';
            end
        end
        
        function [V,w] = getControl(obj,t)
            if t < obj.tIdle
                V = 0; w = 0;
            elseif t > obj.tArray(end)+obj.tIdle
                V = 0; w = 0;
            else
                t = t-obj.tIdle;
                V = interp1(obj.tArray,obj.VArray,t);
                w = interp1(obj.tArray,obj.wArray,t);
            end
        end
        
         function hf = plot(obj)
            hf = figure;
            plot(obj.poseArray(1,:),obj.poseArray(2,:));
            axis equal; xlabel('x'); ylabel('y');
        end
    end
    
end

