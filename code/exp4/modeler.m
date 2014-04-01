%end-to-end pixel modeler

%% initialize
clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27

inputData.poses = poses;
inputData.rHist = rh;
inputData.obsArray = obsArray(:,rh.pixelIds);
totalPoses = length(inputData.poses);
frac = 0.7;
inputData.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
inputData.testPoseIds = setdiff(1:totalPoses,inputData.trainPoseIds);
dp = dataProcessor(inputData);

%% fit pdf models to training data
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
trainPdfs = pdfModeler(inputData);

%% initialize regressor
% nonparametric 
load map;
inputData = struct('envLineMap',roomLineMap,'maxRange',dp.rHist.maxRange,'bearings',dp.rHist.bearings);
p2ra = poses2RAlpha(inputData);
inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@nonParametricRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct());
pxRegBundle = pixelRegressorBundle(inputData);

%% predict at test poses
predParamArray = pxRegBundle.predict(dp.XTest);

%% diagnose error
% fit pdf models to test data
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
testPdfs = pdfModeler(inputData);
seTest = (testPdfs.paramArray-predParamArray).^2;
err = errorStats(seTest);
paramRMSE = err.getParamRMSE();
