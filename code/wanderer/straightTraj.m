classdef straightTraj < handle & abstractTrajectory
    %swingStraight from start, turn and move straight to goal
        
    properties
        start; goal
        tStraight
        dist;
        VMax = 0.1;
    end
    
    methods
        function obj = straightTraj(start,dist)
            obj.start = start;
            obj.goal = obj.start+dist*[cos(obj.start(3)); sin(obj.start(3)); 0];
            obj.dist = dist;
            obj.tStraight = abs(obj.dist)/obj.VMax;
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tIdle+obj.tStraight+obj.tIdle;
        end
        
        function state = getPoseAtTime(obj,t)
            if t <= obj.tIdle
                state = obj.start;
            elseif (t > obj.tIdle) && (t <= obj.tIdle+obj.tStraight)
                d = obj.dist*(t-obj.tIdle)/obj.tStraight;
                state = obj.start+d*[cos(obj.start(3)); sin(obj.start(3)); 0];
            else
                state = obj.goal;
            end
        end
        
        function [V,w] = getControl(obj,t)
            if (t > obj.tIdle) && (t <= obj.tIdle+obj.tStraight)
                V = sign(obj.dist)*obj.VMax; w = 0;
            else
                V = 0; w = 0;
            end
        end
        
    end
end