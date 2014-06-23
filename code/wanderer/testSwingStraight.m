if exist('rob','var')
    if rob.timerUp
        rob.shutdown;
    end
end
clear all; close all; clc;
%start = [0; 0; 0]; goal = 0.5*[cos(pi/3); sin(pi/3); 0];
start = [0; 0; 0]; goal = [-1; 0; 0];
rob = neato('sim');
rob.sim_robot.pose = start;
rstate = robState(rob,'robot',start);

%traj = swingStraight(start,goal);
traj = backupTrajectory(start,goal);
ctrl = controllerClass(struct('gainV',0.09,'gainW',0.05));
trajFl = trajectoryFollower(struct('trajectory',traj,'controller',ctrl));
trajFl.execute(rob,rstate);

%% plot stuff
trajFl.plotLogs;