function outputStruct = offlineNeato(inputStruct)
% Note. Sometimes delay-based execution performs poorly without a pause().
% But the pause should not be longer than the updatePeriod.

% Parse inputStruct.
tInputV = inputStruct.tInputV;
inputVlLog = inputStruct.inputVlLog;
inputVrLog = inputStruct.inputVrLog;
duration = inputStruct.duration;
if isfield(inputStruct,'pose0')
	pose0 = inputStruct.pose0;
else
	pose0 = [0; 0; 0];
end
if isfield(inputStruct,'map')
	map = inputStruct.map;
else
	map = [];
end
if isfield(inputStruct,'plotting')
	plotting = inputStruct.plotting;
else
	plotting = 0;
end
if isfield(inputStruct,'poseMsgFreq')
	poseMsgFreq = inputStruct.poseMsgFreq;
else
	poseMsgFreq = 10;
end
	
% Construct sim_robot.
load sim_options
components = constructComponentsFromOptions(options);
sim_robot = constructSimRobotFromComponents(components);
sim_robot.fireUpForRealTime();
sim_robot.pose = pose0;

% Map.
sim_robot.setMap(map);

% Neato robot, for plotting.
if plotting
	plotRob = neato('sim');
end

% Updator options.
updatePeriod = 1/50;
tPause = 0;
localTimeLog = [];

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
nextPoseMsgTime = 1/poseMsgFreq;

% Pad inputs logs.
[inputVlLog,inputVrLog,tInputV] = padInputLogs(inputVlLog,inputVrLog,tInputV,duration);

flag = (tInputV(end)-tInputV(1)) > duration;
assert(flag,'INPUT VELOCITIES RUN OUT BEFORE DURATION.');

% Start clocks.
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
		% Send input velocity to sim_robot.
		if localTime > tInputV(1)
			vl = interp1(tInputV,inputVlLog,localTime);
			vr = interp1(tInputV,inputVrLog,localTime);
		else
			vl = 0; vr = 0;
		end
		sim_robot.inputModule.sendVelocity(vl,vr,localTime);
				
		% Update sim_robot state.
		sim_robot.updateStateStep(localTime);
		% Some checks.
		if any(isnan(sim_robot.pose))
			me = MException('offlineNeato:poseError','sim robot pose is nan');
			throw(me);
		end
		
		% Update plotted robot.
		if plotting
			plotRob.sim_robot.pose = sim_robot.pose;
		end
		
		% Update encoder logs.
		if localTime > nextEncMsgTime
			encLog(countEncLog).left = sim_robot.encoders.data.left;
			encLog(countEncLog).right = sim_robot.encoders.data.right;
			tEnc(countEncLog) = localTime;
			countEncLog = countEncLog+1;
			nextEncMsgTime = nextEncMsgTime+1/encMsgFreq;
		end
		
		% Update laser logs.
		if localTime > nextLzrMsgTime
			lzrLog(countLzrLog).ranges = sim_robot.getLaserReadings();
			tLzr(countLzrLog) = localTime;
			countLzrLog = countLzrLog+1;
			nextLzrMsgTime = nextLzrMsgTime+1/lzrMsgFreq;
		end
		
		% Update pose logs.
		if localTime > nextPoseMsgTime
			poseLog(:,countPoseLog) = sim_robot.pose;
			tPose(countPoseLog) = localTime;
			countPoseLog = countPoseLog+1;
			nextPoseMsgTime = nextPoseMsgTime+1/poseMsgFreq;
		end
		
		tPause = tPause+toc(clockComp);
		clockLastUpdate = tic();
% 		pause(0.001); % For luck.
	end
end

% Get rid of plot robot.
if plotting
	plotRob.shutdown();
	close all;
	clear plotRob;
end

% Create outStruct
outputStruct = inputStruct;
outputStruct.encLog = encLog; outputStruct.tEnc = tEnc;
outputStruct.lzrLog = lzrLog; outputStruct.tLzr = tLzr;
outputStruct.poseLog = poseLog; outputStruct.tPose = tPose;
outputStruct.updatePeriod = updatePeriod;
outputStruct.tCompStruct = sim_robot.getCompTime();
outputStruct.simOptions = options;
end