% specify environment
fNameMap = 'straight_corridor';
load(fNameMap);
fNameSupport = [fNameMap '_support'];
load(fNameSupport);
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%% get training and test poses
% check: pose of sensor or pose of robot?
N = 300;
poses = uniformSamplesOnSupport(map,support,bBox,N);
NTrain = ceil(0.6*N);
NHold = ceil(0.5*(N-NTrain));
NTest = N-NTrain-NHold;
trainIds = randsample(1:N,NTrain);
holdIds = randsample(setdiff(1:N,trainIds),NHold);
testIds = setdiff(1:N,union(trainIds,holdIds));
M = 50;

%% generate poses for dynamic objects
load([fNameMap '_dynamic_supports']);
dynamicXLen = 0.2;
dynamicYLen = 0.05;
dynamicBBox.xv = [-1 1 1 -1 -1]*dynamicXLen*0.5;
dynamicBBox.yv = [-1 -1 1 1 -1]*dynamicYLen*0.5;
minDynamicObjects = 2;
maxDynamicObjects = 5; % in each strip
dynamicPosesList = cell(1,N);

for i = 1:N
    % don't want people to walk on objects
    mapWithRobot = lineMap(map.objects);
    tBBox = transformPolygon(poses(:,i),bBox);
    robotObject = lineObject();
    robotObject.lines = zeros(length(bBox.xv),2);
    robotObject.lines(:,1) = tBBox.xv;
    robotObject.lines(:,2) = tBBox.yv;
    mapWithRobot.addObject(robotObject);

    dynamicPoses = [];
    for support = supports
        nDynamicObjects = randsample(minDynamicObjects:maxDynamicObjects,1);
        dynamicPoses = [dynamicPoses, ...
            uniformSamplesOnSupport(mapWithRobot,support,dynamicBBox,nDynamicObjects)];
    end
    dynamicPosesList{i} = dynamicPoses;
end

%% vizPoses
hf = vizPoses(map,poses,1:N,[]);
hold on;
for i = 1:N
    dynamicPoses = dynamicPosesList{i};
    plot(dynamicPoses(1,:),dynamicPoses(2,:),'r+');
end

%% specify sensor model
% laser gencal
load sim_sep6_1.mat
sensorModel = rsim;
% scrub hacks
sensorModel.setMap(map);
sensorModel.laser = laserClass(struct());
sensor = sensorModel.laser;
nBearings = sensorModel.laser.nBearings;
for i = 1:length(sensorModel.pxRegBundleArray)
    sensorModel.pxRegBundleArray(i).nBearings = nBearings;
end

%% simulate sensor readings
% get poses of dynamic objects
% for each state [x,y]
% specify the static and the dynamic map
% raycast in the static and the dynamic map
% figure out which bearings intersect dynamic obstacles
% half probability ranges are dynamic, half static

% simulate sensor readings
obsArray = cell(N,nBearings);
clockLocal = tic();
for i = 1:N
	readings = zeros(M,nBearings);
    staticMap = lineMap(map.objects);
    staticMapRanges = staticMap.raycast(poses(:,i),sensor.maxRange,sensor.bearings);
    
    % create dynamic map
    dynamicMap = lineMap(map.objects);
    dynamicPoses = dynamicPosesList{i};
    dynamicObjects = [];
    for j = 1:size(dynamicPoses,2)
        tBBox = transformPolygon(dynamicPoses(:,j),dynamicBBox);
        dynamicObject = lineObject();
        dynamicObject.lines = zeros(length(dynamicBBox.xv),2);
        dynamicObject.lines(:,1) = tBBox.xv;
        dynamicObject.lines(:,2) = tBBox.yv;
        dynamicMap.addObject(dynamicObject);
    end
    
    dynamicMapRanges = dynamicMap.raycast(poses(:,i),sensor.maxRange,sensor.bearings);
    dRanges = abs(staticMapRanges-dynamicMapRanges);
    dynamicHitBearings = dRanges > 1e-4; % arbitrary threshold
    
    
    sensorModel.setMap(staticMap);
    for j = 1:M/2
		readings(j,:) = sensorModel.simulate(poses(:,i));
    end
    sensorModel.setMap(dynamicMap);
    for j = M/2+1:M
		readings(j,:) = sensorModel.simulate(poses(:,i));
    end
        
	for j = 1:nBearings
		obsArray{i,j} = readings(:,j);
	end
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
in.pre = '../data/';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-dynamic-env';
in.date = yymmddDate();
in.index = '';
fname = buildDataFileName(in);
save(fname,'fNameMap','map','bBox',...
    'N','M','poses','trainIds','holdIds','testIds',...
    'dynamicBBox','minDynamicObjects','maxDynamicObjects','dynamicPosesList',...
    'sensorModel','sensor','obsArray');

