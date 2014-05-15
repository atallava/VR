%end-to-end pixel modeler

%% initialize
clear all; clear classes; clc;
addpath ~/Documents/MATLAB/neato_utils/
load processed_data_mar27
%load full_rangeHistogram_mar27
%load synthetic_data_mar27

fprintf('Initializing...\n');
inputData.poses = poses;
inputData.rHist = rh;
inputData.obsArray = obsArray(:,rh.pixelIds);
totalPoses = length(inputData.poses);
frac = 0.7;
%inputData.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
inputData.trainPoseIds = [1    21    17    38     6    32    27    29    24    35    28    40    10     4    34    13     8     9    31    11 23    22    37    15     7    33    41     5    42];
inputData.testPoseIds = setdiff(1:totalPoses,inputData.trainPoseIds);
dp = dataProcessor(inputData);

%% fit pdf models to training data
fprintf('Fitting pixel models...\n');
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
trainPdfs = pdfModeler(inputData);
%trainPdfs.markOutliers();

%% initialize regressor
fprintf('Initializing regressor(s)...\n');
load map;
inputData = struct('envLineMap',roomLineMap,'maxRange',dp.rHist.maxRange,'bearings',dp.rHist.bearings);
p2ra = poses2RAlpha(inputData);
p2r = poses2R(inputData);
localizer = lineMapLocalizer(lines_p1,lines_p2);

trainMuArray = trainPdfs.paramArray(:,1,:);
trainSigmaArray = trainPdfs.paramArray(:,2,:);
trainPzArray = trainPdfs.paramArray(:,3,:);

% hack hack hack. throwing outliers in regression stage
thresh = 0.05;
nominalRange = p2r.transform(dp.XTrain);
flag = (trainMuArray > nominalRange+thresh) | (trainMuArray < nominalRange-thresh);
trainMuArray(flag) = nan;
trainSigmaArray(flag) = nan;

% nonparametric
inputData = struct('XTrain',dp.XTrain,'YTrain',trainMuArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2r, ...
    'regClass',@locallyWeightedLinearRegressor, 'kernelFn', @kernelR, 'kernelParams',struct('h',0.0025));
%h = 0.055, lambda = 0.1, np
%h = 0.0025 lwl
%h 0.0058, 0.0384 locallyWeightedLinear nonParametric
muPxRegBundle = pixelRegressorBundle(inputData);

inputData = struct('XTrain',dp.XTrain,'YTrain',trainSigmaArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@nonParametricRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',0.0559,'lambda',0.1));
sigmaPxRegBundle = pixelRegressorBundle(inputData);

inputData = struct('XTrain',dp.XTrain,'YTrain',trainPzArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@nonParametricRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',0.0559,'lambda',0.1));
pzPxRegBundle = pixelRegressorBundle(inputData);
%{
% baseline
inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,...
    'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
    'regClass',@baselineRegressor); 
pxRegBundle = pixelRegressorBundle(inputData);
%}

%% predict at test poses
fprintf('Predicting...\n');

predMuArray = muPxRegBundle.predict(dp.XTest);
predSigmaArray = sigmaPxRegBundle.predict(dp.XTest);
predPzArray = pzPxRegBundle.predict(dp.XTest);

predParamArray(:,1,:) = predMuArray;
predParamArray(:,2,:) = predSigmaArray;
predParamArray(:,3,:) = predPzArray;

% baseline
%predParamArray = pxRegBundle.predict(dp.XTest);

%% diagnose error
% fit pdf models to test data
fprintf('Calculating error...\n');
inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
testPdfs = pdfModeler(inputData);
errTest = abs(testPdfs.paramArray-predParamArray);
err = errorStats(errTest);
[paramME,nOutliers] = err.getParamME();
