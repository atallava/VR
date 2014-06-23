classdef pose2D < handle
    
    properties (SetAccess = private)
        x
        y
        th
        R
        T
    end
    
    methods(Static = true)
        function res = poseNorm(p1,p2)
           % p1, p2 are [x,y,th]
           scale = 0.5;
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
            obj.T = [obj.R [obj.x; obj.y]; ...
                0 0 1];
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
        
        function xnew = transformPoints(obj,x)
           % x is of size 2 x num points or 3 x num points
           if size(x,1) == 2
               x = [x; ones(1,size(x,2))];
           end
           xnew = obj.T*x;
           xnew(3,:) = [];
        end
        
        function p = getPose(obj)
            p = [obj.x; obj.y; obj.th];
        end
    end
    
end

