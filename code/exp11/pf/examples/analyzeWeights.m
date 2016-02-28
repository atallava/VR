% load readings
fnameReadings = '../data/pf_readings_wide_corridor_s_traj';
load(fnameReadings,'map','dynamicMapList','poseHistory','readings','sensor','support','tHistory','traj');

%% pick an observation at random
% get observation readings
obsIds = [];
for i = 1:length(readings)
    if strcmp(readings(i).type,'observation')
        obsIds = [obsIds i];
    end
end
readingId = randsample(obsIds,1);
% readingId = 1;
obsCount = floor(readingId+1)*0.5;

fprintf('Reading id: %d\n',readingId);
fprintf('obsCount: %d\n',obsCount);

% pose
pose = poseHistory(:,obsCount);

% dynamic map
dynamicMap = dynamicMapList{obsCount};

%% generate a set of particles
xyScale = 1;
thScale = deg2rad(10); % in rad
fnameRobotBBox = '../data/robot_bbox';
load(fnameRobotBBox,'robotBBox');

% sample around initial pose
initDistSampler = @(map,support,bBox,xyScale,thScale) ...
    initParticlesUniformAroundPose(map,support,bBox,xyScale,thScale,pose);

% probe pattern
% initDistSampler = @(map,support,bBox,xyScale,thScale) ...
%     initParticlesProbePattern(map,support,bBox,xyScale,thScale,pose);

particles = initDistSampler(map,support,robotBBox,xyScale,thScale);

% retain PMax particles
PMax = 15;
if length(particles) > PMax
    ids = randsample(1:length(particles),PMax);
    particles = particles(ids);
end

particlePoses = [particles.pose];

%% weights from thrun
bearingSkip = 10;
powerScale = 0.05;
thrunModelParams = [0.2 1.0477 0.8575];
obsModel = @(map,sensor,ranges,bearings,particles) ...
    getWeightsThrun(map,sensor,ranges,bearings,particles,thrunModelParams);

ranges = readings(readingId).data.ranges;
bearings = sensor.bearings;
[ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);
[weights,obsModelStruct] = obsModel(map,sensor,ranges,bearings,particles);

% plot particles
hf = vizParticles(dynamicMap,particles,weights);
% plot true pose
hold on;
scatter(pose(1),pose(2,:),15,'b','filled');
quiverScale = 0.4;
hq = quiver(pose(1),pose(2),quiverScale*cos(pose(3)),quiverScale*sin(pose(3)),...
    'b','LineWidth',2,'autoscale','off');
title(sprintf('reading: %d',readingId));

%% weights from npreg
bearingSkip = 10;
powerScale = 1e-3;
% npreg weights
fnameNPRegPredictor = '../data/npreg_predictor';
load(fnameNPRegPredictor,'npRegPredictor');
% smoothing matrix
fnameSmoothingMatrix = '../data/hist_smoothing_matrix_401';
load(fnameSmoothingMatrix,'smoothingMatrix');
obsModel = @(map,sensor,ranges,bearings,particles) ...
    getWeightsNPReg(map,sensor,ranges,bearings,particles,npRegPredictor,smoothingMatrix);

ranges = readings(readingId).data.ranges;
bearings = sensor.bearings;
[ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);
[weights,obsModelStruct] = obsModel(map,sensor,ranges,bearings,particles);
           
% plot particles
hf = vizParticles(dynamicMap,particles,weights);
% plot true pose
hold on;
scatter(pose(1),pose(2,:),15,'b','filled');
quiverScale = 0.4;
hq = quiver(pose(1),pose(2),quiverScale*cos(pose(3)),quiverScale*sin(pose(3)),...
    'b','LineWidth',2,'autoscale','off');
title(sprintf('reading: %d',readingId));
