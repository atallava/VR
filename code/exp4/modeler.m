%end-to-end model

%% initialize
clearAll;
load processed_data_sep6

fprintf('Initializing...\n');
inputStruct = struct('poses',poses,'obsArray',{obsArray(:,pixelIds)},'laser',robotModel.laser);
totalPoses = length(inputStruct.poses);
%frac = 0.7; inputStruct.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
inputStruct.trainPoseIds = trainPoseIds;
inputStruct.testPoseIds = testPoseIds;
dp = dataProcessor(inputStruct);

%% fit pdf models to training data
fprintf('Fitting pixel models...\n');
inputStruct = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
trainPdfs = pdfBundle(inputStruct);
%trainPdfs.markOutliers();

%% initialize regressors
fprintf('Initializing regressor(s)...\n');
load roomLineMap;
inputStruct = struct('envLineMap',map,'laser',dp.laser);
p2ra = poses2RAlpha(inputStruct);
p2r = poses2R(inputStruct);
localizer = lineMapLocalizer(map.objects);

trainMuArray = trainPdfs.paramArray(:,1,:);
trainSigmaArray = trainPdfs.paramArray(:,2,:);
trainPzArray = trainPdfs.paramArray(:,3,:);

% % hack hack hack. throwing outliers in regression stage
% thresh = 0.05;
% nominalRange = p2r.transform(dp.XTrain);
% flag = (trainMuArray > nominalRange+thresh) | (trainMuArray < nominalRange-thresh);
% trainMuArray(flag) = nan;
% trainSigmaArray(flag) = nan;

% switches to account for laser.maxRange
bsMu = boxSwitch(struct('XRanges',[0; dp.laser.maxRange],'switchY',nan));
bsSigma = boxSwitch(struct('XRanges',[0 0; dp.laser.maxRange 2*pi],'switchY',nan));

inputStruct = struct('XTrain',dp.XTrain,'YTrain',trainMuArray,'poolOption',0,'inputPoseTransf', p2ra, ...
    'regClass',@locallyWeightedLinearRegressor,'XSpaceSwitch',bsMu,'kernelFn',@kernelRAlpha, 'kernelParams',struct('h',0.0025,'lambda',0));
%h = 0.055, lambda = 0.1, np
%h = 0.0025 lwl
%h 0.0058, 0.0384 locallyWeightedLinear nonParametric
muPxRegBundle = pixelRegressorBundle(inputStruct);

inputStruct = struct('XTrain',dp.XTrain,'YTrain',trainSigmaArray,'poolOption',1,'inputPoseTransf', p2ra, ...
    'regClass',@nonParametricRegressor, 'XSpaceSwitch',bsSigma,'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',0.0559,'lambda',0.1));
sigmaPxRegBundle = pixelRegressorBundle(inputStruct);

inputStruct = struct('XTrain',dp.XTrain,'YTrain',trainPzArray,'inputPoseTransf', p2ra, ...
    'regClass',@nonParametricRegressor, 'XSpaceSwitch',bsSigma,'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',0.0559,'lambda',0.1));
pzPxRegBundle = pixelRegressorBundle(inputStruct);

%{
% baseline
inputStruct = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,'inputPoseTransf', p2ra, ...
    'regClass',@baselineRegressor); 
pxRegBundle = pixelRegressorBundle(inputStruct);
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
inputStruct = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
testPdfs = pdfBundle(inputStruct);
errTest = abs(testPdfs.paramArray-predParamArray);
err = errorStats(errTest);
[paramME,nOutliers] = err.getParamME();

%% create a simulator instance
fprintf('Creating simulator...\n');
inputStruct = struct('fitClass',trainPdfs.fitClass,'pxRegBundleArray',[muPxRegBundle sigmaPxRegBundle pzPxRegBundle], ...
    'laser',dp.laser,'map',map);
rsim = rangeSimulator(inputStruct);