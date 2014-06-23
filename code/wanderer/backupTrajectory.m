classdef backupTrajectory < handle & abstractTrajectory
    %backupTrajectory backup robot in a straight line
        
    properties (Constant = true)
        backupDist = 0.05;
    end
    
    properties
        start; goal
        tStraight
        dist
        VMax = 0.2; %robotModel.vMax;
    end
    
    methods
        function obj = backupTrajectory(start,goal)
            obj.start = start; obj.start(3) = mod(obj.start(3),2*pi);
            obj.goal = goal;
            
            vec = goal(1:2)-start(1:2);
            obj.dist = norm(vec);
            obj.tStraight = obj.dist/obj.VMax;
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tIdle+obj.tStraight+obj.tIdle;
        end
        
        function state = getPoseAtTime(obj,t)
            if t <= obj.tIdle
                state = obj.start;
            elseif (t > obj.tIdle) && (t <= obj.tIdle+obj.tStraight)
                vec = obj.goal(1:2)-obj.start(1:2);
                state(1:2) = obj.start(1:2)+vec*(obj.tIdle+obj.tStraight-t)/obj.tStraight;
                state(3) = obj.start(3);
            else
                state = obj.goal;
            end
        end
        
        function [V,w] = getControl(obj,t)
            if t <= obj.tIdle
                V = 0; w = 0;
            elseif (t > obj.tIdle) && (t <= obj.tIdle+obj.tStraight)
                V = -obj.VMax; w = 0;
            else
                V = 0; w = 0;
            end
        end
    end
    
    methods (Static = true)
        function bPose = getBackedUpPose(pose)
            th = pose(3);
            bPose = pose-backupTrajectory.backupDist*[cos(th); sin(th); 0];
        end
    end
    
end

