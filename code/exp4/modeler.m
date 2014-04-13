%end-to-end pixel modeler

%% initialize
clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27
load full_rangeHistogram_mar27
%load synthetic_data_mar27

fprintf('initializing\n');
inputData.poses = poses;
inputData.rHist = rh;
inputData.obsArray = obsArray(:,rh.pixelIds);
totalPoses = length(inputData.poses);
frac = 0.7;
inputData.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
inputData.testPoseIds = setdiff(1:totalPoses,inputData.trainPoseIds);
dp = dataProcessor(inputData);

%% fit pdf models to training data
fprintf('fitting pixel models\n');
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
trainPdfs = pdfModeler(inputData);
trainPdfs.markOutliers();

%% initialize regressor
fprintf('initializing regressor\n');
load map;
inputData = struct('envLineMap',roomLineMap,'maxRange',dp.rHist.maxRange,'bearings',dp.rHist.bearings);
p2ra = poses2RAlpha(inputData);
localizer = lineMapLocalizer(lines_p1,lines_p2);
%{
% nonparametric
inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@locallyWeightedLinearRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',0.0025,'lambda',0));
%h 0.0058, 0.0384 locallyWeightedLinear nonParametric
%}

% baseline
inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@baselineRegressor); 

pxRegBundle = pixelRegressorBundle(inputData);

%% predict at test poses
fprintf('predicting\n');
predParamArray = pxRegBundle.predict(dp.XTest);

%% diagnose error
% fit pdf models to test data
fprintf('calculating error\n');
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
testPdfs = pdfModeler(inputData);
errTest = abs(testPdfs.paramArray-predParamArray);
err = errorStats(errTest);
[paramME,nOutliers] = err.getParamME();
