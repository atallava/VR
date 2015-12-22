% prepare workspace
if exist('rob','var') 
    if rob.timerUp
        rob.shutdown();
    end
end
clear all; close all; clc;
load roomLineMap;
rng('shuffle');

% get robot
rob = neato('sim');
rob.genMap(map.objects);
rob.startLaser;

imagesDirName = 'images/scan_match';
poseStart = [0.25;0.25;0];
rob.sim_robot.pose = poseStart; % For simulation, set robot at start pose estimate.
pause(1);

%% use function
wandererData(rob,map,poseStart,imagesDirName);

%% test script
% initialize objects
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));
ctrl = controllerClass(struct());
ctrlBackup = controllerClass(struct('gainV',0.1));
pgen = poseGenerator(struct('map',map));
encLog = encHistory(rob);
lzrLog = laserHistory(rob);
refinerLog = struct('stats',{});

% initialize variables
[~,pose] = refiner.refine(rob.laser.data.ranges,poseStart);
rstate = robState(rob,'robot',pose);
pgen.addToPoseHist(pose);

fname = sprintf('data_%s',datestr(now,'mmmdd')); fname = lower(fname);
tRangeCollection = struct('start',{},'end',{});
numScansPerPose = 2;
recCount = 1;
nPoses = 3;
maxBackups = 5;
outlierFracnThreshold = 0.5;
for i = 1:nPoses
    % get next goal state
    success = false;
    backupCount = 0;
    while ~success && backupCount <= maxBackups
        sampledPose = pgen.sample(pose);
        if isempty(sampledPose)
            % backup
            bPose = backupTrajectory.getBackedUpPose(pose);
            trajBackup = backupTrajectory(pose,bPose);
            if ~exist('trajFlrBackup','var')
                trajFlrBackup = trajectoryFollower(struct('trajectory',trajBackup,'controller',ctrlBackup));
            else
                trajFlrBackup.resetTrajectory(trajBackup);
            end
            
            fprintf('Backing up...\n');
            % execute traj, get pose and reset rstate
            trajFlrBackup.execute(rob,rstate);
            [refinerStats,pose] = refiner.refine(rob.laser.data.ranges,rstate.pose);
            %pose = rob.sim_robot.pose; % PLACEHOLDER: read off exact state
            rstate.reset(pose);
            pause(robotModel.tPause);
            backupCount = backupCount+1;
        else
            goal = sampledPose;
            success = true;
            break;
        end
    end
    if ~success
        warning('NO POSE FOUND EVEN AFTER BACKUPS.');
        break;
    end
    fprintf('Pose %d...\n',i);
    
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
    
    fprintf('Performing scan match...\n');
    [refinerStats,pose] = refiner.refine(rob.laser.data.ranges,rstate.pose);
    if refinerStats.numOutliers/length(rob.laser.data.ranges) > outlierFracnThreshold
        warning('NUMBER OF OUTLIERS IN SCAN EXCEEDS THRESHOLD. POSE ESTIMATE NO LONGER RELIABLE.');
        break;
    end
        
    refinerLog(end+1).stats = refinerStats;
    % estimate pose using scan match
    poseIn = rstate.pose;
    ranges = rob.laser.data.ranges;

    % visualize scan match
    if exist('hf','var')
        close(hf);
    end
    hf = vizer.viz(rob.laser.data.ranges,pose); 
    set(hf,'visible','off'); title('After refining.'); 
    print('-dpng','-r72',sprintf('images/scan_match/scan_match_%d.png',i));
        
    pgen.addToPoseHist(pose);
    rstate.reset(pose);
    pause(robotModel.tPause);
    
    % collectData
    tRangeCollection(recCount).start = lzrLog.tArray(end);
    fprintf('Collecting range data...\n\n\n');
    for j = 1:numScansPerPose
        pause(0.3);
    end
    tRangeCollection(recCount).end = lzrLog.tArray(end);
    if mod(i,5) == 0
        save(fname,'lzrLog','encLog','pgen','tRangeCollection','refinerLog');
    end
    beep; beep; % alert grad student
    pause(0.1);
end

% stop loggers
encLog.stopListening();
lzrLog.stopListening();
fprintf('Writing to file...\n');
save(fname,'lzrLog','encLog','pgen','tRangeCollection','refinerLog');

rob.stopLaser;
fprintf('Finished.\n');



