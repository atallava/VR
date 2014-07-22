%% Initialize
clearAll;
load ../processed_data_mar27.mat
load ../roomLineMap

localizer = lineMapLocalizer(map.objects);
visualizer = vizRangesOnMap(struct('localizer',localizer));
refiner = laserPoseRefiner(struct('localizer',localizer,'numIterations',40));

%% Select poses
%2,9,18,19,21,22,30,39
poseId = 30;
ranges = rangesFromObsArray(obsArray,poseId,10);
pose = poses(:,poseId);
visualizer.viz(ranges,pose);

%% Generate pattern set
rhoRange = [0.05 0.5];
thRange = deg2rad([-15 15]);
nPatternSet = 50;
patternSet = zeros(3,nPatternSet);
for i = 1:nPatternSet
    rho = unifrnd(rhoRange(1),rhoRange(2));
    phi = rand*2*pi;
    th = unifrnd(thRange(1),thRange(2));
    patternSet(:,i) = [rho*cos(phi); rho*sin(phi); th];
end

%% How many observations needed? 
poseId = 2;
nObs = 100;
obsIds = randperm(length(obsArray{poseId,1}),nObs);
vec = [];
for obsId = obsIds
    ranges = rangesFromObsArray(obsArray,poseId,obsId);
    poseIn = poses(:,poseId)+patternSet(:,1);
    [success,poseOut] = refiner.refine(ranges,poseIn);
    vec(end+1) = success.err;
    fprintf('%d\n',length(vec));
end

% after 20 observations, change in mean of success.err < 2%, change in
% variance of success.err < 7%

%% Generate application test data
poseIds = [2,18,30,39];
nObs = 20;
data = struct('pose',{},'ranges',{});
for i = 1:length(poseIds)
    data(i).pose = poses(:,poseIds(i));
    obsIds = randperm(length(obsArray{poseIds(i),1}),nObs);
    data(i).ranges = rangesFromObsArray(obsArray,poseIds(i),obsIds);
end