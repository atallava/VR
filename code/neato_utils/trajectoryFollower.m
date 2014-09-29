classdef trajectoryFollower < handle
    %trajectoryFollower
    % carrot follower

    properties (Constant)
        LOG_SIZE = 100000;
    end
    properties (SetAccess = private)
        trajectory
        controller
        VFfLog; wFfLog; VFbLog; wFbLog
        vlLog; vrLog;
        tEncStart; tLaserStart
        tLog; refStateLog; currentStateLog;
    end

    methods
        function obj = trajectoryFollower(inputStruct)
            % inputStruct fields ('trajectory','controller')
            % default (,)
            if isfield(inputStruct,'trajectory')
                obj.trajectory = inputStruct.trajectory;
            else
                error('TRAJECTORY NOT INPUT');
            end
            if isfield(inputStruct,'controller')
                obj.controller = inputStruct.controller;
            else
                error('CONTROLLER NOT INPUT');
            end
            obj.resetLogs;
        end
        
        function execute(obj,rob,rstate)
            obj.resetLogs;
            logCount = 1;
            update_count_old = rstate.update_count;
            % Zero in encoder clock.
            obj.tEncStart = rob.encoders.data.header.stamp.secs + rob.encoders.data.header.stamp.nsecs*1e-9;
			tClock = tic;
            oldRState = rstate.pose;
            currentTh = rstate.pose(3); 
            while(toc(tClock) < obj.trajectory.getTrajectoryDuration)
                while update_count_old == rstate.update_count
                    pause(robotModel.tPause);
                    continue;
                end
                update_count_old = rstate.update_count;
                tNew = toc(tClock); 
                
                % feedforward
                [VFf,wFf] = obj.trajectory.getControl(tNew);
                V = VFf; w = wFf;
                
                % feedback
                currentState = rstate.pose;
                dTh = thDiff(oldRState(3),currentState(3));
                currentTh = currentTh+dTh;
                currentState(3) = currentTh;
                oldRState = rstate.pose;
                refState = obj.trajectory.getPoseAtTime(tNew);
                [VFb,wFb] = obj.controller.computeControl(tNew,refState,currentState);
                V = V+VFb; w = w+wFb;
                [vl,vr] = robotModel.Vw2vlvr(V,w);
                [vl,vr] = robotModel.scaleWheelVel(vl,vr);
                rob.sendVelocity(vl,vr);
                
                % logging
                obj.tLog(logCount) = tNew;
%                 obj.VFfLog(logCount) = VFf; obj.wFfLog(logCount) = wFf;
%                 obj.VFbLog(logCount) = VFb; obj.wFbLog(logCount) = wFb;
                obj.vlLog(logCount) = vl; obj.vrLog(logCount) = vr;
%                 obj.refStateLog(:,logCount) = refState; obj.currentStateLog(:,logCount) = currentState;
                logCount = logCount+1;
                
                pause(robotModel.tPause);
            end
            rob.sendVelocity(0,0);
        end
        
        function plotLogs(obj,skip)
            if nargin < 2
                skip = 10;
            end
            last = find(obj.tLog == 0);
            if isempty(last)
                last = length(trajectoryFollower.LOG_SIZE);
            else
                last = last(1)-1;
            end
            ids = 1:skip:last;
            figure;
            %quiver(obj.refStateLog(1,ids),obj.refStateLog(2,ids),0.1*cos(obj.refStateLog(3,ids)),0.1*sin(obj.refStateLog(3,ids)),'b','LineWidth',2); hold on;
            %quiver(obj.currentStateLog(1,ids),obj.currentStateLog(2,ids),0.1*cos(obj.currentStateLog(3,ids)),0.1*sin(obj.currentStateLog(3,ids)),'r','LineWidth',2);
            plot(obj.refStateLog(1,ids),obj.refStateLog(2,ids),'b+'); hold on;
            plot(obj.currentStateLog(1,ids),obj.currentStateLog(2,ids),'ro','LineWidth',2);
            axis equal; legend('reference state','current state');
            xlabel('x'); ylabel('y');
                        
            figure;
            plot(obj.tLog(ids),obj.VFbLog(ids),'+r'); hold on; plot(obj.tLog(ids),obj.wFbLog(ids),'+b'); legend('VFb','wFb');
            xlabel('t'); ylabel('Vfb,Wfb');
        end
        
        function resetLogs(obj)
            [obj.tLog,obj.VFfLog,obj.wFfLog,obj.VFbLog,obj.wFbLog] = deal(zeros(1,trajectoryFollower.LOG_SIZE));
            [obj.vlLog,obj.vrLog] = deal(zeros(1,trajectoryFollower.LOG_SIZE));
            [obj.refStateLog,obj.currentStateLog] = deal(zeros(3,trajectoryFollower.LOG_SIZE));
        end

        function resetTrajectory(obj,trajectory)
            obj.trajectory = trajectory;
            obj.resetLogs;
        end
        
        function setController(obj,ctrl)
            obj.controller = ctrl;
        end
    end

    methods (Static = true)
    end

end
