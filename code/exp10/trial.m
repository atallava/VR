clearAll;
load processed_data_sep6

%% plot like, a whole lot of data.

figure; hold on; axis equal;
poseIds = randperm(length(trainPoseIds),10);
obsId = 2;
ptsBig = [];
for i = 1:length(poseIds)
    poseId = poseIds(i);
    ranges = rangesFromObsArray(obsArray,poseId,obsId);
    ri = rangeImage(struct('ranges',ranges,'bearings',robotModel.laser.bearings));
    pts = [ri.xArray; ri.yArray];
    pts = pose2D.transformPoints(pts,poses(:,poseId));
    ptsBig = [ptsBig pts];
    plot(pts(1,:),pts(2,:),'r.');
end
