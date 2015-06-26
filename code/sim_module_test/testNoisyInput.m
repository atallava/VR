% test noisy inputs in sim
load trajectories
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));
csp = trajectories(1);

%% neato
% turn logging on for simrobot
% set enc delay in neato.m to 0.
rob = neato2('sim'); rstate = robState(rob);
rob.sim_robot.pose = [0 0 pi/2]';
pause(0.5);
rstate.reset(rob.sim_robot.pose);
pause(0.5);
tfl.resetTrajectory(csp);
tfl.execute(rob,rstate);
pause(0.5);
rob.shutdown();

%%
vlArray = tfl.vlLog(1:tfl.lastIdLogs);
vrArray = tfl.vrLog(1:tfl.lastIdLogs);
tArray = tfl.tLog(1:tfl.lastIdLogs);
poseArray = rstate.pose_history(:,1:rstate.motion_count-1);

%%
sr1 = rob1.sim_robot;
sr2 = rob2.sim_robot;
figure; hold on; 
plot(sr1.logArrayX,sr1.logArrayY,'b');
plot(sr2.logArrayX,sr2.logArrayY,'r');

figure; hold on; 
plot(sr1.logArrayT,sr1.logArrayW,'b');
plot(sr2.logArrayT,sr2.logArrayW,'r');

