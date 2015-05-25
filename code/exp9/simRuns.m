% run neato in sim to test code
load trajectories
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));
csp = trajectories;

%%
% needs rob, rstate to exist in workspace
nPoses = 15;
dataCommVel = struct('startPose',{},'finalPose',{},'vlArray',{},'tArray',{});
encLogs = struct('log',{},'tArray',{});

enc = encHistory(rob);
for i = 1:nPoses
	fprintf('Trajectory %d...\n',i);
	enc.reset();
	rob.sim_robot.pose = [0 0 pi/2]';
	pause(0.5);
	% get pose
	rstate.reset(rob.sim_robot.pose);
	pause(0.5);
	dataCommVel(i).startPose = rob.sim_robot.pose;
	tfl.resetTrajectory(csp(i));
	tfl.execute(rob,rstate);
	pause(0.5);
	% commanded velocity data
	encLogs(i).log = enc.log;
	encLogs(i).tArray = enc.tArray;
	dataCommVel(i).vlArray = tfl.vlLog(1:tfl.lastIdLogs);
	dataCommVel(i).vrArray = tfl.vrLog(1:tfl.lastIdLogs);
	dataCommVel(i).tArray = tfl.tLog(1:tfl.lastIdLogs);
	poseHistory{i} = rstate.pose_history(:,1:rstate.motion_count-1);
	% encoder velocity data
	% get pose
	dataCommVel(i).finalPose = rob.sim_robot.pose;
end

enc.stopListening;
% this is highly inefficient
dataEncVel = getDataEncVel(dataCommVel,encLogs);

%%
save('sim_data','dataCommVel','dataEncVel','poseHistory');