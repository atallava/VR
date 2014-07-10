classdef pose2D < handle
    
    properties (SetAccess = private)
        x; y; th
        R; T
    end
    
    methods(Static = true)
        function res = poseNorm(p1,p2)
           % p1, p2 are [x,y,th]
           scale = 0.5/0.44;
           dth = atan2(sin(p1(3)-p2(3)),cos(p1(3)-p2(3)));
           res = (p1(1)-p2(1))^2+(p1(2)-p2(2))^2+(scale*dth)^2;
           res = sqrt(res);
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
            T = [cos(p(3)) -sin(p(3)) p(1); ...
                sin(p(3)) cos(p(3)) p(2); ...
                0 0 1];
        end
        
        function p = transformToPose(T)
            theta = atan2(T(2,1),T(1,1));
            p = [T(1,3); T(2,3); theta];
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
        
        function ptsNew = transformPoints(pts,pose)
            % x is of size 2 x num points or 3 x num points
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

