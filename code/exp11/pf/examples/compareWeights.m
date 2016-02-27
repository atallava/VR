% load readings
fnameReadings = '../data/pf_readings';
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
obsCount = floor(readingId+1)*0.5;

% pose
pose = poseHistory(:,obsCount);

% dynamic map
dynamicMap = dynamicMapList{obsCount};

%% generate a set of particles
xyScale = 0.1;
thScale = deg2rad(2); % in rad
fnameRobotBBox = '../data/robot_bbox';
load(fnameRobotBBox,'robotBBox');
% sample around initial pose
initDistSampler = @(map,support,bBox,xyScale,thScale) ...
    initParticlesAroundPose(map,support,bBox,xyScale,thScale,pose);
PMax = 50;
particles = initDistSampler(map,support,robotBBox,xyScale,thScale);
% retain PMax particles
if length(particles) > PMax
    ids = randsample(1:length(particles),PMax);
    particles = particles(ids);
end

%% weights from thrun
bearingSkip = 10;
powerScale = 0.05;
thrunModelParams = [0.0229 0.9 0.8603];
obsModel = @(map,sensor,ranges,bearings,particles) ...
    getWeightsThrun(map,sensor,ranges,bearings,particles,thrunModelParams);

ranges = readings(readingId).data.ranges;
bearings = sensor.bearings;
[ranges,bearings] = subsampleRanges(ranges,bearings,bearingSkip);
weights = obsModel(map,sensor,ranges,bearings,particles);
           
vizParticles(dynamicMap,particles,weights);

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
weights = obsModel(map,sensor,ranges,bearings,particles);
           
vizParticles(dynamicMap,particles,weights);
