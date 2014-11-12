%% initialize
cond = logical(exist('rob','var'));
assert(cond,('ROB MUST EXIST IN WORKSPACE'));
cond = logical(exist('map','var'));
assert(cond,('MAP MUST EXIST IN WORKSPACE'));
cond = logical(exist('rstate','var'));
assert(cond,('RSTATE MUST EXIST IN WORKSPACE'));
cond = isfield(rob.laser.data,'header');
assert(cond,'LASER MUST BE ON!');

load trajectories;
ctrl = controllerClass(struct('gainV',0,'gainW',0));
tfl = trajectoryFollower(struct('trajectory',[],'controller',ctrl));

dataCommVel = struct('startPose',{},'finalPose',{},'vlArray',{},'tArray',{});
encLogs = struct('log',{},'tArray',{});

localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate)); 
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));

%% collect data
nominalStartPose = [0.5; 0.5; pi/2];
enc = encHistory(rob);
for i = 1:length(trajectories)
	% position robot
	input('Press any key when ready. ');
	% when in sim...
% 	rob.sim_robot.pose = nominalStartPose(); 
	rstate.reset(nominalStartPose);
	pause(0.5);

	fprintf('Run %d...\n',i);
	% get start pose
	fprintf('Getting start pose...\n');
	localized = 0;
	while ~localized
		ranges = rob.laser.data.ranges;
		pause(0.5);
		[refinerStats,pose] = refiner.refine(ranges,rstate.pose);
		rstate.reset(pose);
		pause(0.5);
		localized = input('Localized? (0/1): ');
	end
	dataCommVel(i).startPose = rstate.pose;
	enc.reset(); 
	pause(1);
	
	% execute trajectory
	fprintf('Executing trajectory...\n');
	tfl.resetTrajectory(trajectories(i));
	tfl.execute(rob,rstate);
	pause(0.5);
	
	% log data
	encLogs(i).log = enc.log;
	encLogs(i).tArray = enc.tArray;
		
	% get final pose
	fprintf('Getting final pose...\n');
	localized = 0;
	while ~localized
		ranges = rob.laser.data.ranges;
		pause(0.5);
		[refinerStats,pose] = refiner.refine(ranges,rstate.pose);
		rstate.reset(pose);
		pause(0.5);
		localized = input('Localized? (0/1): ');
	end

	% log data
	dataCommVel(i).vlArray = tfl.vlLog(1:tfl.lastIdLogs);
	dataCommVel(i).vrArray = tfl.vrLog(1:tfl.lastIdLogs);
	dataCommVel(i).tArray = tfl.tLog(1:tfl.lastIdLogs);
	dataCommVel(i).finalPose = rstate.pose;
	
	fname = input('Save data? (filename/0): ');
	if fname
		dataEncVel = getDataEncVel(dataCommVel,encLogs);
		save(fname,'dataCommVel','dataEncVel');
		fprintf('Written to file...\n');
	end
	fprintf('\n');
end

enc.stopListening();
rob.stopLaser();
vizer.delete();