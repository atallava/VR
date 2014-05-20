function avgError = errorOnBaselineSigma(dataProcInput,K)
%errorOnBaselineSigma compute average error for parameter K that is used to
% calculate std in the baseline predictor

load map;
inputData = struct('envLineMap',roomLineMap,'laser',dataProcInput.laser);
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
    trainPdfs.markOutliers();

    % initialize regressor
    inputData = struct('XTrain',dp.XTrain,'YTrain',trainPdfs.paramArray,'poseTransf', p2ra, ...
        'regClass',@baselineRegressor, 'K', K);
    pxRegBundle = pixelRegressorBundle(inputData);

    % predict at test poses
    predParamArray = pxRegBundle.predict(dp.XTest);

    % diagnose error
    % fit pdf models to test data
    inputData = struct('fitClass',@normWithDrops,'data',{dp.obsArray(dp.testPoseIds,:)});
    testPdfs = pdfModeler(inputData);
    errTest = abs(testPdfs.paramArray-predParamArray);
    err = errorStats(errTest);
    paramME = err.getParamME();
    avgError = avgError+paramME;
end
avgError = avgError/numTrials;
avgError = avgError(2);

end

