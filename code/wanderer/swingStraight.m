classdef swingStraight < handle & abstractTrajectory
    %swingStraight from start, turn and move straight to goal
        
    properties
        start; goal
        tSwing; tStraight
        phi; dist; thFinal
        bBox
        wMax = 1; %robotModel.wMax;
        VMax = 0.2; %robotModel.vMax;
    end
    
    methods
        function obj = swingStraight(start,goal)
            obj.start = start; obj.start(3) = mod(obj.start(3),2*pi);
            obj.goal = goal;
            
            vec = goal(1:2)-start(1:2);
            th = start(3); 
            obj.thFinal = atan2(vec(2),vec(1));
            obj.phi = atan2(sin(obj.thFinal-th),cos(obj.thFinal-th));
            obj.dist = norm(vec);
            obj.tSwing = abs(obj.phi)/obj.wMax;
            obj.tStraight = obj.dist/obj.VMax;
            obj.computeTrajBBox();
        end
        
        function res = getTrajectoryDuration(obj)
            res = obj.tIdle+obj.tSwing+obj.tIdle+obj.tStraight+obj.tIdle;
        end
        
        function state = getPoseAtTime(obj,t)
            if t <= obj.tIdle
                state = obj.start;
            elseif (t > obj.tIdle) && (t <= obj.tIdle+obj.tSwing)
                state = obj.start;
                th = obj.start(3)+obj.phi*(t-obj.tIdle)/obj.tSwing;
                state(3) = th;
            elseif (t > obj.tIdle+obj.tSwing) && (t <= obj.tIdle+obj.tSwing+obj.tIdle)
                state = obj.start;
                state(3) = obj.thFinal;
            elseif (t > obj.tIdle+obj.tSwing+obj.tIdle) && (t <= obj.tIdle+obj.tSwing+obj.tIdle+obj.tStraight)
                vec = obj.goal(1:2)-obj.start(1:2);
                state(1:2) = obj.start(1:2)+(t-(obj.tIdle+obj.tSwing+obj.tIdle))/obj.tStraight*vec;
                state(3) = obj.thFinal;
            else
                state = obj.goal;
                state(3) = obj.thFinal;
            end
        end
        
        function [V,w] = getControl(obj,t)
            if (t > obj.tIdle) && (t <= obj.tIdle+obj.tSwing)
                V = 0; w = sign(obj.phi)*obj.wMax;
            elseif (t > obj.tIdle+obj.tSwing+obj.tIdle) && (t <= obj.tIdle+obj.tSwing+obj.tIdle+obj.tStraight)
                V = obj.VMax; w = 0;
            else
                V = 0; w = 0;
            end
        end
        
        function computeTrajBBox(obj)
            pose = obj.start; pose(3) = obj.thFinal;
            bBox1 = robotModel.getTransformedBBox(pose);
            pose = obj.goal; pose(3) = obj.thFinal;
            bBox2 = robotModel.getTransformedBBox(pose);
            obj.bBox = [bBox1(3:4,:); bBox2(1:2,:); bBox1(3,:)];
        end
        
    end
end




