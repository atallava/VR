% first scan match to get start pose correct
clear all; clc;
load nsh1_corridor
load raw_poses
load raw_ranges
angles = deg2rad(-130:0.25:129.75);
localizer = lineMapLocalizer(lines_p1, lines_p2);

%% get start pose

dpose = [3.36; -42.8; deg2rad(-92)];
poseEst = pose2D(raw_poses(:,1)+dpose);
rr = squeeze(raw_ranges(1,1,:)); rr = rr';
ri = rangeImage(rr,angles); ri.cleanup(0.01,5);
ptsLocal = [ri.xArray; ri.yArray; ones(1,length(ri.xArray))];
ptsLocal = ptsLocal(:,1:4:end);
outIds = localizer.throwOutliers(poseEst,ptsLocal);
ptsLocal(:,outIds) = [];
numIters = 300;
poseOut = poseEst;
for i = 1:numIters
    [flag, poseOut] = localizer.refinePose(poseOut,ptsLocal,1);
    err(i) = flag.err;
end

%% see what it looks like
hf = localizer.drawLines();
hf = plotScan(poseOut,ptsLocal,hf);

%% visualize how good/bad odometry is
load start_pose
T = transformBetweenPoses(raw_poses(:,[1,3,16]),[newpose1 newpose3 newpose16]);
poses = transformPoses(T,raw_poses);

for i = 1:size(poses,2)
   rr = squeeze(raw_ranges(i,1,:));
   ri = rangeImage(rr,angles); ri.cleanup(0.01,5);
   ptsLocal = [ri.xArray; ri.yArray; ones(1,length(ri.xArray))];
   hf = localizer.drawLines();
   hf = plotScan(pose2D(poses(:,i)),ptsLocal,hf);
   hold on
   xRob = poses(1,i); yRob = poses(2,i); thRob = poses(3,i);
   quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(thRob),'k','LineWidth',2);
   quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(raw_poses(3,i)),'r','LineWidth',2);
   title(sprintf('pose %d',i));
   k = waitforbuttonpress;
   close(hf);
end

%% test range matching for particular pose
clc;

poseId = 13;
poseEst = pose2D(poses(:,poseId));
rr = squeeze(raw_ranges(poseId,1,:)); rr = rr';
ri = rangeImage(rr,angles); ri.cleanup(0.01,5);
ptsLocal = [ri.xArray; ri.yArray; ones(1,length(ri.xArray))];
ptsLocal = ptsLocal(:,1:4:end);
outIds = localizer.throwOutliers(poseEst,ptsLocal);
ptsLocal(:,outIds) = [];
[success, poseOut] = localizer.refinePose(poseEst,ptsLocal,100);

%% range matching for all 
T = transformBetweenPoses(raw_poses(:,[1,3,16]),[newpose1 newpose3 newpose16]);
poses = transformPoses(T,raw_poses);
posesFromRangeMatch = zeros(3,42);

for poseId = 1:size(poses,2)
    fprintf('pose %d\n',poseId);
    poseEst = pose2D(poses(:,poseId));
    rr = squeeze(raw_ranges(poseId,1,:));
    ri = rangeImage(rr,angles); ri.cleanup(0.01,5);
    
    % laser range points in robot local frame
    ptsLocal = [ri.xArray; ri.yArray; ones(1,length(ri.xArray))];
    outIds = localizer.throwOutliers(poseEst,ptsLocal);
    ptsLocal(:,outIds) = [];
    ptsLocal = ptsLocal(:,1:4:end);
    [success, poseOut] = localizer.refinePose(poseEst,ptsLocal,200);
    posesFromRangeMatch(:,poseId) = poseOut.getPose();

    % pretty printing
    hf = localizer.drawLines();
    hf = plotScan(poseEst,ptsLocal,hf);
    hf = plotScan(poseOut,ptsLocal,hf);
    set(hf,'visible','off');
    ha = findobj(hf,'type','axes'); 
    hl = findobj(ha,'type','line');
    legend(hl(1:2),{'poseOut','poseEst'});
    xlim([-2 4]); ylim([-2 3]);
    title(sprintf('pose %d, observation %d',poseId,1));
    print('-dpng','-r72',sprintf('scan_match/p%d_o%d.png',poseId,1));
    close(hf);
end