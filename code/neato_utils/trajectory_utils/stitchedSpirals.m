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
        
        function poses = getPoseAtTime(obj,t)
            poses = zeros(3,length(t));
            
            % before start of motion
            ids1 = t < obj.tIdle;
            poses(:,ids1) = repmat(obj.startPose,1,sum(ids1));
            % after end of motion
            ids2 = t > obj.tArray(end)+obj.tIdle;
            poses(:,ids2) = repmat(obj.finalPose,1,sum(ids2));
            % otherwise
            ids3 = ~(ids1 | ids2);
            x = interp1(obj.tArray,obj.poseArray',t(ids3)-obj.tIdle);
            poses(:,ids3) = x';
		end
        
		function [V,w] = getControl(obj,t)
			%GETCONTROL Get reference velocities at time t.
			%
			% [V,w] = GETCONTROL(obj,t)
			%
			% t   - Time in s.
			%
			% V   - Linear velocity.
			% w   - Angular velocity.
			
			[V,w] = deal(zeros(size(t)));
			ids1 = t < obj.tIdle;
			ids2 = t > obj.tArray(end)+obj.tIdle;
			ids3 = ~(ids1 | ids2);
			t(ids3) = t(ids3)-obj.tIdle;
			V(ids3) = interp1(obj.tArray,obj.VArray,t(ids3));
			w(ids3) = interp1(obj.tArray,obj.wArray,t(ids3));
        end
        
         function hf = plot(obj)
            hf = figure;
            plot(obj.poseArray(1,:),obj.poseArray(2,:));
            axis equal; xlabel('x'); ylabel('y');
        end
    end
    
end

