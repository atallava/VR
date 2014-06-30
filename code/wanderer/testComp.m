if exist('rob','var') 
    if rob.timerUp
        rob.shutdown();
    end
end
clear all; close all; clc;
load map;
rng('shuffle');

pgen = poseGenerator(struct('map',roomLineMap));
start = [0.25;0.25;0]; %PLACEHOLDER: set start. get from scan-match
pgen.addToPoseHist(start);

nPoses = 100;
maxBackups = 5;

ctrl = controllerClass(struct());
ctrlBackup = controllerClass(struct('gainV',0.1));
rob = neato('sim');
rob.sim_robot.pose = start;
rob.genMap(roomLineMap.objects);
rstate = robState(rob,'robot',start);
pose = start; 

rob.startLaser;
localizer = lineMapLocalizer(roomLineMap.objects);
vizRanges = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser));

for i = 1:nPoses
    % get goal state
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
            pose = rob.sim_robot.pose; % PLACEHOLDER: read off exact state
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
    t1 = tic();
    [success,poseOut] = refiner.refine(ranges,poseIn); 
    fprintf('scan match took %fs\n',toc(t1));
    % PLACEHOLDER: read off exact state
    pose = rob.sim_robot.pose;
    lPose = laser.refPoseToLaserPose(pose);
    lPoseOut = laser.refPoseToLaserPose(poseOut);
    lPoseIn = laser.refPoseToLaserPose(poseIn);
    hf1 = vizRealRanges(localizer,ranges,lPoseOut); title('lPoseOut');
    hf2 = vizRealRanges(localizer,ranges,lPose); title('lPose');
    waitforbuttonpress; close(hf1,hf2);
    
    pgen.addToPoseHist(pose);
    rstate.reset(pose);
    pause(robotModel.tPause);
    
    % collectData
    
end

%%
h1 = figure; hold on;
for i = 1:length(pgen.sampleHistory)
    quiver(pgen.sampleHistory(1,i),pgen.sampleHistory(2,i),0.1*cos(pgen.sampleHistory(3,i)),0.1*sin(pgen.sampleHistory(3,i)),'r','LineWidth',2);
    quiver(pgen.poseHistory(1,i+1),pgen.poseHistory(2,i+1),0.1*cos(pgen.poseHistory(3,i+1)),0.1*sin(pgen.poseHistory(3,i+1)),'b','LineWidth',2);
    waitforbuttonpress
end




