% common paramters
% parameters
% readings
fnameReadings = '../data/pf_readings_wide_corridor_s_traj';

% debug or not
debugFlag = 0;

% init dist params
fnameRobotBBox = '../data/robot_bbox';
load(fnameRobotBBox,'robotBBox');
% sample around initial pose
% needed for initial pose
load(fnameReadings,'poseHistory');
initDistSampler = @(map,support,bBox,xyScale,thScale) ...
    initParticlesUniformAroundPose(map,support,bBox,xyScale,thScale,poseHistory(:,1));

% motion model params
fnameMotionNoise = '../data/pf_motion_noise';
load(fnameMotionNoise,'etaV','etaW');

% observation model params
bearingSkip = 10;
powerScale = 1e-3;
% npreg weights
fnameNPRegPredictor = '../data/npreg_predictor';
load(fnameNPRegPredictor,'npRegPredictor');
% smoothing matrix
fnameSmoothingMatrix = '../data/hist_smoothing_matrix';
load(fnameSmoothingMatrix,'smoothingMatrix');
obsModel = @(map,sensor,ranges,bearings,particles) ...
    getWeightsNPReg(map,sensor,ranges,bearings,particles,npRegPredictor,smoothingMatrix);

% resampler params
resampler = @lowVarianceResampler;

% viz pf progress
vizFlag = 0;

% save
saveRes = 1;

%% pack into struct
% init dist
initDistParams.robotBBox = robotBBox;
initDistParams.initDistSampler = initDistSampler;

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

%% build up input structs
count = 1;

% low init dist variance, low number of particles
inputStructs{count} = inputStruct;
inputStructs{count}.initDistParams.xyScale = 0.1;
inputStructs{count}.initDistParams.thScale = deg2rad(5);
inputStructs{count}.initDistParams.PMax = 100;
inputStructs{count}.fnameRes = sprintf('../data/npreg_exp/pf_res_npreg_exp_%d',count);
count = count+1;

% low init dist variance, high number of particles
inputStructs{count} = inputStruct;
inputStructs{count}.initDistParams.xyScale = 0.1;
inputStructs{count}.initDistParams.thScale = deg2rad(5);
inputStructs{count}.initDistParams.PMax = 500;
inputStructs{count}.fnameRes = sprintf('../data/npreg_exp/pf_res_npreg_exp_%d',count);
count = count+1;

% high init dist variance, low number of particles
inputStructs{count} = inputStruct;
inputStructs{count}.initDistParams.xyScale = 1;
inputStructs{count}.initDistParams.thScale = deg2rad(10);
inputStructs{count}.initDistParams.PMax = 100;
inputStructs{count}.fnameRes = sprintf('../data/npreg_exp/pf_res_npreg_exp_%d',count);
count = count+1;

% high init dist variance, high number of particles
inputStructs{count} = inputStruct;
inputStructs{count}.initDistParams.xyScale = 1;
inputStructs{count}.initDistParams.thScale = deg2rad(10);
inputStructs{count}.initDistParams.PMax = 500;
inputStructs{count}.fnameRes = sprintf('../data/npreg_exp/pf_res_npreg_exp_%d',count);
count = count+1;

nTrials = 30;

%% run experiments
runPfExperiments(inputStructs,nTrials);















