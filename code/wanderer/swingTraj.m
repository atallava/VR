classdef swingTraj < handle & abstractTrajectory
    %swingStraight from start, turn and move straight to goal
        
    properties
        start; goal
        tSwing; tStraight
        dTh; dist; thFinal
        bBox
        wMax = 0.15;
    end
    
    methods
        function obj = swingTraj(start,dTh)
            obj.start = start; obj.start(3) = mod(obj.start(3),2*pi);
            obj.dTh = dTh;
            obj.goal = obj.start+[0;0;dTh]; 
                        
            obj.tSwing = abs(obj.dTh)/obj.wMax;
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tIdle+obj.tSwing+obj.tIdle;
        end
        
        function state = getPoseAtTime(obj,t)
            if t <= obj.tIdle
                state = obj.start;
            elseif (t > obj.tIdle) && (t <= obj.tIdle+obj.tSwing)
                state = obj.start;
                th = obj.start(3)+obj.dTh*(t-obj.tIdle)/obj.tSwing;
                state(3) = th;
            else
                state = obj.goal;
            end
        end
        
        function [V,w] = getControl(obj,t)
            if (t > obj.tIdle) && (t <= obj.tIdle+obj.tSwing)
                V = 0; w = sign(obj.dTh)*obj.wMax;
            else
                V = 0; w = 0;
            end
        end
        
    end
end