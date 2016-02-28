classdef pose2D < handle
    
    properties (SetAccess = private)
        x; y; th
        R; T
    end
    
    methods(Static = true)
        function res = poseNorm(p1,p2)
            %POSENORM Weighted euclidean norm in (x,y,theta).
            %
            % res = POSENORM(p1,p2)
            %
            % p1  - [3,1] size array.
            % p2  - [3,1] size array.
            %
            % res - Scalar.
            
            scale = 0.5/0.44;
           pd = pose2D.poseDiff(p1,p2);
		   res = sqrt(pd(1,:).^2+pd(2,:).^2+scale.*pd(3,:).^2);
        end
    end
    methods
        function obj = pose2D(pose)
            % pose is of form [x,y,th]
            obj.updatePose(pose);
        end
        
        function obj = updatePose(obj,pose)
            obj.x = pose(1);
            obj.y = pose(2);
            obj.th = mod(pose(3),2*pi);
            obj.R = obj.rotmat2D(obj.th);
            obj.T = pose2D.poseToTransform(pose);
        end
        
        function Rot = rotmat2D(obj,th)
            Rot = [cos(th) -sin(th); ...
                sin(th) cos(th)];
        end
        
        function Trans = Tb2w(obj)
            % body to world coordinates
            Trans = obj.T;
        end
        
        function Trans = Tw2b(obj)
            % world to body coordinates
            Trans = inv(obj.T);
        end
        
        function p = getPose(obj)
            p = [obj.x; obj.y; obj.th];
        end
    end
    
	methods (Static = true)
		function T = poseToTransform(p)
			%POSETOTRANSFORM
			%
			% T = POSETOTRANSFORM(p)
			%
			% p - Length 3 vector or [3,numPoses] array.
			%
			% T - [3,3] array or length numPoses cell of [3,3] arrays.
			
			if iscolumn(p) || isrow(p)
				T = [cos(p(3)) -sin(p(3)) p(1); ...
					sin(p(3)) cos(p(3)) p(2); ...
					0 0 1];
            else
                numPoses = size(p,2);
				T = cell(1,numPoses);
				for i = 1:numPoses
					T{i} = pose2D.poseToTransform(p(:,i));
				end
			end
		end
        
		function p = transformToPose(T)
			%TRANSFORMTOPOSE
			%
			% p = TRANSFORMTOPOSE(T)
			%
			% T - [3,3] array or length numPoses cell of [3,3] arrays.
			%
			% p - Length 3 vector or [3,numPoses] array.

			if ~iscell(T)
				theta = atan2(T(2,1),T(1,1));
				p = [T(1,3); T(2,3); theta];
				return;
			else
				numPoses = length(T);
				p = zeros(3,numPoses);
				for i = 1:numPoses
					p(:,i) = pose2D.transformToPose(T{i});
				end
			end
        end
        
        function dp = poseDiff(p1,p2)
            %POSEDIFF
            %
            % dp = POSEDIFF(p1,p2)
            %
            % p1 - Pose 1.
            % p2 - Pose 2.
            %
            % dp - Takes p1 to p2.
            
			dp = bsxfun(@minus,p2,p1);
            dp(3) = thDiff(p1(3),p2(3));
        end
        
        function p2 = pose1ToPose2(p1,Tp2_p1)
            % Tp2_p1 takes p2 to p1
            objInput = isa(p1,'pose2D');
            if ~objInput
                p1 = pose2D(p1);
            end
            Tp1 = p1.T; Tp2 = Tp1*Tp2_p1;
            p2 = pose2D.transformToPose(Tp2);
            if objInput
                p2 = pose2D(p2);
            end
        end
        
        function p3 = addPoses(p1,p2)
            p3 = p1+p2;
            p3(3) = mod(p3(3),2*pi);
        end
        
        function ptsNew = transformPoints(pts,pose)
            %TRANSFORMPOINTS
            %
            % ptsNew = TRANSFORMPOINTS(pts,pose)
            %
            % pts    - Array of size 2 x num points or 3 x num points.
            % pose   - Array of length 3.
            %
            % ptsNew - Array of size pts
            
            isH = size(pts,1) == 3;
            if ~isH
                pts = [pts; ones(1,size(pts,2))];
            end
            ptsNew = pose2D.poseToTransform(pose)*pts;
            if ~isH
                ptsNew(3,:) = [];
            end
        end
    end
end

