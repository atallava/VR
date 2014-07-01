function avgError = errorOnKernelWidth(dataProcInput,h,lambda)
%errorOnBinWidth compute average error for some kernel window size
% and weighting factor

load map;
inputStruct = struct('envLineMap',roomLineMap,'laser',dataProcInput.laser);
p2ra = poses2RAlpha(inputStruct);
frac = 0.7;
totalPoses = length(dataProcInput.poses);
numTrials = 1;
avgError = 0;

for i = 1:numTrials
    dataProcInput.trainPoseIds = randperm(totalPoses,floor(frac*totalPoses));
    dataProcInput.testPoseIds = setdiff(1:totalPoses,dataProcInput.trainPoseIds);
    dp = dataProcessor(dataProcInput);

    % fit pdf models to training data
    inputStruct = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.trainPoseIds,:)});
    trainPdfs = pdfBundle(inputStruct);
    trainPdfs.markOutliers();

    % initialize regressor
    inputStruct = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,'poseTransf', p2ra, ...
        'regClass',@nonParametricRegressor, 'kernelFn', @kernelRAlpha, 'kernelParams',struct('h',h,'lambda',lambda));
    pxRegBundle = pixelRegressorBundle(inputStruct);

    % predict at test poses
    predParamArray = pxRegBundle.predict(dp.XTest);

    % diagnose error
    % fit pdf models to test data
    inputStruct = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
    testPdfs = pdfBundle(inputStruct);
    errTest = abs(testPdfs.paramArray-predParamArray);
    err = errorStats(errTest);
    [paramME,~] = err.getParamME();
    avgError = avgError+paramME;
end
avgError = avgError/numTrials;
avgError = avgError(2);

end

