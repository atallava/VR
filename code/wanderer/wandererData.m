function wandererData(rob,map,poseStart,imagesDirName)
% rob is an object of class neato
% map is a lineMap object
% poseStart is an estimate of start pose, length 3 array
% imagesDirName is a string of where to save scan match images to

% initialize objects
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',50));
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
numScansPerPose = 1;
recCount = 1;
nPoses = 10;
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
    
    pause(1);
    % estimate pose using scan match
    % TODO: check if multiple ranges need to be tried in case data is
    % corrupt
    fprintf('Performing scan match...\n');
    [refinerStats,pose] = refiner.refine(rob.laser.data.ranges,rstate.pose);
    if refinerStats.numOutliers/length(rob.laser.data.ranges) > outlierFracnThreshold
        warning('NUMBER OF OUTLIERS IN SCAN EXCEEDS THRESHOLD. POSE ESTIMATE NO LONGER RELIABLE.');
        break;
    end
    refinerLog(end+1).stats = refinerStats;
  
    % visualize scan match
    if exist('hf','var')
        close(hf);
    end
    hf = vizer.viz(rob.laser.data.ranges,pose); 
    set(hf,'visible','off'); title('After refining.'); 
    print('-dpng','-r72',sprintf('%s/scan_match_%d.png',imagesDirName,i));
        
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
    if mod(i,1) == 0
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