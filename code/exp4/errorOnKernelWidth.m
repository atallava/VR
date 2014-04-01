function avgError = errorOnKernelWidth(dataProcInput,h)
%errorOnBinWidth compute average error for some kernel window size

load map;
inputData = struct('envLineMap',roomLineMap,'maxRange',dataProcInput.rHist.maxRange,'bearings',dataProcInput.rHist.bearings);
p2ra = poses2RAlpha(inputData);
frac = 0.7;
totalPoses = length(dataProcInput.poses);
numTrials = 10;
avgError = 0;

for i = 1:numTrials
    dataProcInput.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
    dataProcInput.testPoseIds = setdiff(1:totalPoses,dataProcInput.trainPoseIds);
    dp = dataProcessor(dataProcInput);

    % fit pdf models to training data
    inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
    trainPdfs = pdfModeler(inputData);

    % initialize regressor
    inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,...
        'pixelIds', dp.pixelIds, 'poseTransf', p2ra, ...
        'regClass',@nonParametricRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',h));
    pxRegBundle = pixelRegressorBundle(inputData);

    % predict at test poses
    predParamArray = pxRegBundle.predict(dp.XTest);

    % diagnose error
    % fit pdf models to test data
    inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
    testPdfs = pdfModeler(inputData);
    seTest = (testPdfs.paramArray-predParamArray).^2;
    err = errorStats(seTest);
    paramRMSE = err.getParamRMSE();
    avgError = avgError+paramRMSE;
end
avgError = avgError/numTrials;
avgError = avgError(1)+avgError(2)+avgError(3);

end

