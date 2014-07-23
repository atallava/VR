%% initialize
if ~exist('rob','var')
    error('ROB MUST EXIST IN WORKSPACE');
end
if ~exist('map','var')
    error('MAP MUST EXIST IN WORKSPACE');
end
if ~exist('rstate','var')
    error('RSTATE MUST EXIST IN WORKSPACE');
end

% initialize objects
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser,'rob',rob,'rstate',rstate));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));
ctrl = controllerClass(struct());
ctrlBackup = controllerClass(struct('gainV',0.1));
encLog = encHistory(rob);
lzrLog = laserHistory(rob);
refinerLog = struct('stats',{});

%% test trajectory following
if ~exist('start','var') || ~exist('goal','var')
    error('START AND GOAL STATES MUST EXIST IN WORKSPACE');
end

% create trajectory
traj = swingStraight(pose,goal);

fprintf('Executing trajectory...\n');
% execute trajectory
if ~exist('trajFlr','var')
    trajFlr = trajectoryFollower(struct('trajectory',traj,'controller',ctrl));
else
    trajFlr.resetTrajectory(traj);
end
trajFlr.execute(rob,rstate);

%% scan match
fprintf('Performing scan match...\n');
[refinerStats,pose] = refiner.refine(rob.laser.data.ranges,rstate.pose);
if refinerStats.numOutliers/length(rob.laser.data.ranges) > 
    warning('NUMBER OF OUTLIERS IN SCAN EXCEEDS THRESHOLD. POSE ESTIMATE NO LONGER RELIABLE.');
    break;
end
refinerLog(end+1).stats = refinerStats;

%% reset rstate
rstate.reset(pose);
            