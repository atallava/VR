% run an instance of pf with the classic raycast sensor model

%% parameters
% readings
fnameReadings = '../data/pf_readings_wide_corridor_s_traj';

% debug or not
debugFlag = 1;

% init dist params
xyScale = 1;
thScale = deg2rad(10); % in rad
fnameRobotBBox = '../data/robot_bbox';
load(fnameRobotBBox,'robotBBox');
% sample around initial pose
% needed for initial pose
load(fnameReadings,'poseHistory');
initDistSampler = @(map,support,bBox,xyScale,thScale) ...
    initParticlesUniformAroundPose(map,support,bBox,xyScale,thScale,poseHistory(:,1));
PMax = 200;

% motion model params
fnameMotionNoise = '../data/pf_motion_noise';
load(fnameMotionNoise,'etaV','etaW');

% observation model params
bearingSkip = 10;
powerScale = 1e-3;
% thrun model params
thrunModelParams = [0.0229 0.9 0.8603];
obsModel = @(map,sensor,ranges,bearings,particles) ...
    getWeightsThrun(map,sensor,ranges,bearings,particles,thrunModelParams);

% resampler params
resampler = @lowVarianceResampler;

% viz pf progress
vizFlag = 0;

% save
saveRes = 1;
fnameRes = '../data/pf_thrun_res';

%% pack into struct
% init dist
initDistParams.xyScale = xyScale;
initDistParams.thScale = thScale;
initDistParams.robotBBox = robotBBox;
initDistParams.initDistSampler = initDistSampler;
initDistParams.PMax = PMax;

% motion model
motionModelParams.etaV = etaV;
motionModelParams.etaW = etaW;

% obs model
obsModelParams.obsModel = obsModel;
obsModelParams.powerScale = powerScale;
obsModelParams.bearingSkip = bearingSkip;

% resampler
resamplerParams.resampler = resampler;

% all
inputStruct.fnameReadings = fnameReadings;
inputStruct.debugFlag = debugFlag;
inputStruct.initDistParams = initDistParams;
inputStruct.motionModelParams = motionModelParams;
inputStruct.obsModelParams = obsModelParams;
inputStruct.resamplerParams = resamplerParams;
inputStruct.vizFlag = vizFlag;
inputStruct.saveRes = saveRes;
inputStruct.fnameRes = fnameRes;

%% run filter
runParticleFilter(inputStruct);
