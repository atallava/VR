if exist('rob','var') 
    if rob.timerUp
        rob.shutdown();
    end
end
clear all; close all; clc;
load map;
rng('shuffle');

rob = neato('sim');
rob.genMap(roomLineMap.objects);
rob.startLaser;

localizer = lineMapLocalizer(roomLineMap.objects);
vizRanges = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',30));
ctrl = controllerClass(struct());
ctrlBackup = controllerClass(struct('gainV',0.1));
pgen = poseGenerator(struct('map',roomLineMap));
encLog = encHistory(rob);
lzrLog = laserHistory(rob);

poseStartEst = [0.25;0.25;0];
rob.sim_robot.pose = poseStartEst; % For simulation, set robot at start pose estimate.
[success,poseStart] = refiner.refine(rob.laser.data.ranges,poseStartEst);
rstate = robState(rob,'robot',poseStart);
pgen.addToPoseHist(poseStart);

tRangeCollection = struct('start',{},'end',{});
numScansPerPose = 100;
recCount = 1;
nPoses = 100;
maxBackups = 5;
pose = poseStart; 
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
            if ~exist('trajFlr','var')
                trajFlrBackup = trajectoryFollower(struct('trajectory',trajBackup,'controller',ctrlBackup));
            else
                trajFlrBackup.resetTrajectory(trajBackup);
            end
            
            % execute traj, get pose and reset rstate
            trajFlrBackup.execute(rob,rstate);
            [success,pose] = refiner.refine(rob.laser.data.ranges,rstate.pose);
            %pose = rob.sim_robot.pose; % PLACEHOLDER: read off exact state
            rstate.reset(pose);
            pause(robotModel.tPause);
            backupCount = backupCount+1;
            continue;
        else
            goal = sampledPose;
            success = true;
            break;
        end
    end
    if ~success
        error('NO POSE FOUND EVEN AFTER BACKUPS.');
    end

    % create trajectory
    traj = swingStraight(pose,goal);
    
    % execute trajectory
    if ~exist('trajFlr','var')
        trajFlr = trajectoryFollower(struct('trajectory',traj,'controller',ctrl));
    else
        trajFlr.resetTrajectory(traj);
    end
    trajFlr.execute(rob,rstate);
    
    % estimate pose using scan match
    poseIn = rstate.pose;
    ranges = rob.laser.data.ranges;
    [success,poseOut] = refiner.refine(ranges,poseIn);
    fprintf('scan match took %fs\n',refiner.lastMatchDuration);
    % PLACEHOLDER: read off exact state
    pose = rob.sim_robot.pose;
    hf1 = vizRealRanges(localizer,ranges,poseOut); title('poseOut');
    hf2 = vizRealRanges(localizer,ranges,pose); title('pose');
    waitforbuttonpress; close(hf1,hf2);
    
    pgen.addToPoseHist(pose);
    rstate.reset(pose);
    pause(robotModel.tPause);
    
    % collectData
%     tRangeCollection(recCount).start = lzrLog.tArray(end);
%     fprintf('Collecting data set %d \n', data_count);
%     for j = 1:numScansPerPose
%         pause(0.3);
%     end
%     tRangeCollection(recCount).end = lzrLog.tArray(end);
%     beep; beep; % alert grad student
%     pause(0.1);
end

% stop loggers
% encLog.stopListening();
% lzrLog.stopListening();

%%
h1 = figure; hold on;
for i = 1:length(pgen.sampleHistory)
    quiver(pgen.sampleHistory(1,i),pgen.sampleHistory(2,i),0.1*cos(pgen.sampleHistory(3,i)),0.1*sin(pgen.sampleHistory(3,i)),'r','LineWidth',2);
    quiver(pgen.poseHistory(1,i+1),pgen.poseHistory(2,i+1),0.1*cos(pgen.poseHistory(3,i+1)),0.1*sin(pgen.poseHistory(3,i+1)),'b','LineWidth',2);
    waitforbuttonpress
end




