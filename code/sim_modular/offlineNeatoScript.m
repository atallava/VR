% Note. Sometimes delay-based execution performs poorly without a pause().
% But the pause should not be longer than the updatePeriod.

% Construct robot.
load sim_options
components = constructComponentsFromOptions(options);
robot = constructSimRobotFromComponents(components);
robot.fireUpForRealTime();

% Map.
robot.setMap(map);

% Initial pose.
robot.pose = pose0;

% Neato robot, for plotting.
plotting = 1;
if plotting
	plotRob = neato('sim');
	plotRob.sim_robot.pose = robot.pose;
end

% Updator options.
updatePeriod = 1/50;
tPause = 0;
localTimeLog = [];

% Initialize input velocity stuff.
countInputV = 1;
nextInputTime = tInputV(countInputV);
tInputVActual = []; vlSent = [];

% Initialize encoder stuff.
encLog = struct('left',{},'right',{});
tEnc = [];
countEncLog = 1;
encMsgFreq = 30;
nextEncMsgTime = 1/encMsgFreq;

% Initialize laser stuff.
lzrLog = struct('ranges',{},'intensities',{});
tLzr = [];
countLzrLog = 1;
lzrMsgFreq = 5;
nextLzrMsgTime = 1/lzrMsgFreq;

% Initialize pose stuff.
poseLog = [];
countPoseLog = 1;
poseMsgFreq = 10;
nextPoseMsgTime = 1/poseMsgFreq;

% Pad inputs logs.
[inputVlLog,inputVrLog,tInputV] = padInputLogs(inputVlLog,inputVrLog,tInputV,duration);

flag = (tInputV(end)-tInputV(1)) > duration;
assert(flag,'INPUT VELOCITIES RUN OUT BEFORE DURATION.');

%% Start clocks.
clockLocal = tic();
clockLastUpdate = tic();
while true
	if toc(clockLastUpdate) >= updatePeriod
		localTime = toc(clockLocal)-tPause;
		localTimeLog(end+1) = localTime;
		if localTime > duration
			break;
		end
		
		clockComp = tic(); % Time spent in computation.
		% Send input velocity to robot.
		if localTime > tInputV(1)
			vl = interp1(tInputV,inputVlLog,localTime);
			vr = interp1(tInputV,inputVrLog,localTime);
		else
			vl = 0; vr = 0;
		end
		robot.inputModule.sendVelocity(vl,vr,localTime);
		vlSent = [vlSent vl];
				
		% Update robot state.
		robot.updateStateStep(localTime);
		% Some checks.
		if any(isnan(robot.pose))
			me = MException('offlineNeato:computationError','sim robot pose is nan');
			throw(me);
		end
		
		% Update plot robot.
		if plotting
			plotRob.sim_robot.pose = robot.pose;
		end
		
		% Update encoder logs.
		if localTime > nextEncMsgTime
			encLog(countEncLog).left = robot.encoders.data.left;
			encLog(countEncLog).right = robot.encoders.data.right;
			tEnc(countEncLog) = localTime;
			countEncLog = countEncLog+1;
			nextEncMsgTime = nextEncMsgTime+1/encMsgFreq;
		end
		
		% Update laser logs.
		if localTime > nextLzrMsgTime
			lzrLog(countLzrLog).ranges = robot.getLaserReadings();
			tLzr(countLzrLog) = localTime;
			countLzrLog = countLzrLog+1;
			nextLzrMsgTime = nextLzrMsgTime+1/lzrMsgFreq;
		end
		
		% Update pose logs.
		if localTime > nextPoseMsgTime
			poseLog(:,countPoseLog) = robot.pose;
			tPose(countPoseLog) = localTime;
			countPoseLog = countPoseLog+1;
			nextPoseMsgTime = nextPoseMsgTime+1/poseMsgFreq;
		end

		tPause = tPause+toc(clockComp);
		clockLastUpdate = tic();
		pause(0.001); % For luck.
	end
end

%% Get rid of plot robot
if plotting
	plotRob.shutdown();
	close all;
	clear plotRob;
end