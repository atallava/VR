classdef robotModel < handle
        
    properties (Constant = true)
        W = 0.235 % wheel base in m
		VMax = 0.3 % maximum linear velocity in m/sec
        wMax = 2.553 % maximum angular velocity in rad/sec
        bBox = [0.167 -0.167; 0.167 0.167; -0.167 0.167; -0.167 -0.167; 0.167 -0.167]; % bounding box in m
        tPause = 0.001; % time in sec between sending velocity commands
        Tlaser = [1 0 -0.1; ...
            0 1 0; ...
            0 0 1];
        laser = laserClass(struct('maxRange',4.5,'rangeRes',0.001,'bearings',deg2rad(0:359),'nullReading',0,'Tsensor',robotModel.Tlaser));
    end
    
    methods (Static = true)
        function [vl,vr] =  Vw2vlvr(V,w)
            % VW2VLVR Body to wheel velocities.
            %
            % [vl,vr] =  VW2VLVR(V,w)
            %
            % V  - Body linear velocity.
            % w  - Body angular velocity.
            %
            % vl - Left wheel velocity.
            % vr - Right wheel velocity.
            
            vl = V-w*robotModel.W/2;
            vr = V+w*robotModel.W/2;
        end
        
        function [V,w] =  vlvr2Vw(vl,vr)
            % VLVR2VW Wheel to body velocities.
            %
            % [V,w] =  VLVR2VW(vl,vr)
            %
            % vl - Left wheel velocity.
            % vr - Right wheel velocity.
            %
            % V  - Body linear velocity.
            % w  - Body angular velocity.
            
            V = (vl+vr)*0.5;
            w = (-vl+vr)/robotModel.W;
        end
        
        function p2 = eulerIntegrate(p1,V,w,dt)
            %EULERINTEGRATE
            %
            % p2 = EULERINTEGRATE(p1,V,w,dt)
            %
            % p1 - Input pose.
            % V  - Linear velocity.
            % w  - Angular velocity.
            % dt - Time step.
            %
            % p2 - Output pose.
            
           p2(3) = p1(3)+w*dt; p2(3) = mod(p2(3),2*pi);
           p2(1) = p1(1)+V*cos(p1(3))*dt;
           p2(2) = p1(2)+V*sin(p1(3))*dt;
        end
        
        function [vl,vr] = scaleWheelVel(vl,vr)
            %SCALEWHEELVEL Scale wheel velocities to maximum allowed. 
            %
            % [vl,vr] = SCALEWHEELVEL(vl,vr)
            %
            % vl - Input/output left wheel velocity.
            % vr - Input/output right wheel velocity.
            
            v = max(abs(vl),abs(vr));
            if v == 0
                return;
            end;
            scale = min(v,robotModel.VMax)/v;
            vl = scale*vl;
            vr = scale*vr;
        end
                    
        function tBBox = getTransformedBBox(pose)
            %GETTRANSFORMEDBBOX Orient bBox to align with pose.
            %
            % tBBox = GETTRANSFORMEDBBOX(pose)
            %
            % pose  - Length 3 array.
            %
            % tBBox - 5 x 2 array of coordinates.
            
            Tb2w = pose2D.poseToTransform(pose);
            tBBox = Tb2w*[robotModel.bBox'; ones(1,size(robotModel.bBox,1))];
            tBBox(3,:) = []; tBBox = tBBox';                
        end
    end
    
end

