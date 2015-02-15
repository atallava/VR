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

%% distance between ray and a gaussian
mu = [0; 0];
S = [40 1; 1 0]*1e-1;
p0 = [10; 10];
r = -[1.5; 1]; 
r = r/norm(r);
tmin = (r'/S)*(mu-p0);
tmin = tmin/(r'/S*r);

%%
clearAll
load carving_data_sep6
nPts = size(poses,2)*laser.nPixels;
[p0,pts,r] = deal([]);

for i = 1:size(poses,2)
    ranges = rangesFromObsArray(obsArray,i,obsIds);
    ri = rangeImage(struct('ranges',ranges,'bearings',laser.bearings));
    ptsI = [ri.xArray; ri.yArray];
    ptsI = pose2D.transformPoints(ptsI,poses(:,i));
    pts = [pts ptsI];
    p0I = repmat(poses(1:2,i),1,laser.nPixels*length(obsIds));
    p0 = [p0 p0I];
    rI = ptsI-p0I;
    rINorm = sqrt(sum(rI.^2,1));
    rI = bsxfun(@rdivide,rI,rINorm);
    r = [r rI];
end

