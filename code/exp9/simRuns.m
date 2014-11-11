load trajectories
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));

%%
% needs rob, rstate to exist in workspace

nPoses = 2;
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
	dataCommVel(i).startPose = rstate.pose;
	tfl.resetTrajectory(csp(i));
	tfl.execute(rob,rstate);
	pause(0.5);
	% commanded velocity data
	encLogs(i).log = enc.log;
	encLogs(i).tArray = enc.tArray;
	dataCommVel(i).vlArray = tfl.vlLog(1:tfl.lastIdLogs);
	dataCommVel(i).vrArray = tfl.vrLog(1:tfl.lastIdLogs);
	dataCommVel(i).tArray = tfl.tLog(1:tfl.lastIdLogs);
	% encoder velocity data
	% get pose
	dataCommVel(i).finalPose = rstate.pose;
end

enc.stopListening;
dataEncVel = getDataEncVel(dataCommVel,encLogs);