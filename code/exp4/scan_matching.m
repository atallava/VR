%% initialize
clear all; clc;
load processed_data_mar27
addpath ~/Documents/MATLAB/neato_utils/

nPoses = length(poses);
angles = deg2rad(0:359);
obsId = 100;
xw = [0 3.66 3.66 0 0];
yw = [0 0 1.83 1.83 0];
xobs = [1.525 2.135];
yobs = [.915 .915];

lines_p1 = [xw(1:end-1) xobs(1); yw(1:end-1) yobs(1)];
lines_p2 = [xw(2:end) xobs(2); yw(2:end) yobs(2)];
localizer = lineMapLocalizer(roomLineMap.objects);

%% visualize range images at processed poses
for i = 1:nPoses
    ranges = rangesFromObsArray(obsArray,i,obsId);
    %ranges = obsArray(i,obsId,:); ranges = squeeze(ranges);
    poseObj = pose2D(poses(:,i));
    riObj = rangeImage(struct('ranges',ranges,'cleanup',1));
    ptsLocal = [riObj.xArray; riObj.yArray; ones(1,riObj.npix)];
    hf = localizer.drawLines();
    outIds = localizer.throwOutliers(poseObj,ptsLocal);
    ptsLocal(:,outIds) = [];
    hf = plotScan(poseObj,ptsLocal,hf);
    title(sprintf('pose %d',i));
    k = waitforbuttonpress;
    close(hf);
end

%% range matching
clear ranges; clc;
posesFromRangeMatch = zeros(3,nPoses);
for poseId = 1:nPoses
    fprintf('pose %d\n',poseId);
    poseEst = pose2D(poses(:,poseId));
    %ranges = obsArray(poseId,obsId,:); ranges = squeeze(ranges);
    ranges = rangesFromObsArray(obsArray,poseId,obsId);
    ri = rangeImage(struct('ranges',ranges,'cleanup',1));
    % laser range points in robot local frame
    ptsLocal = [ri.xArray; ri.yArray];
    ptsLocal = [ptsLocal; ones(1,size(ptsLocal,2))];
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
    xlim([-0.5 4]); ylim([-0.5 2]);
    title(sprintf('pose %d, observation %d',poseId,obsId));
    print('-dpng','-r72',sprintf('images/scan_match/p%d_o%d.png',poseId,obsId));
    close(hf);
end

%% test range matching for particular pose
clc;

poseId = 31;
poseEst = pose2D(poses(:,poseId));
numIter = 100;
err = zeros(1,numIter);
poseArray = zeros(3,numIter);
%ranges = obsArray(poseId,obsId,:); ranges = squeeze(ranges);
ranges = rangesFromObsArray(obsArray,poseId,obsId);
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
% laser range points in robot local frame
ptsLocal = [ri.xArray; ri.yArray];
ptsLocal = [ptsLocal; ones(1,size(ptsLocal,2))];
for i = 1:numIter
    fprintf('iteration %d\n',i);
    [success, poseEst] = localizer.refinePose(poseEst,ptsLocal,1);
    err(i) = success.err;
    poseArray(:,i) = poseEst.getPose();
   
    % pretty printing
    hf = localizer.drawLines();
    hf = plotScan(poseEst,ptsLocal,hf);
    set(hf,'visible','off');
    xlim([-0.5 4]); ylim([-0.5 2]);
    title(sprintf('iteration %d',i));
    print('-dpng','-r72',sprintf('images/iterations/p%d_i%d.png',poseId,i));
    close(hf);
end
