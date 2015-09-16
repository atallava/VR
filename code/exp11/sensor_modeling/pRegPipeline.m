% pReg pipeline for ascension modeling
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150821'; 
in.index = '2';
fileName = buildDataFileName(in);
load(fileName);

%%
% CHECK PARAMETERS BEFORE ESTIMATING!
bwXMu = [0.5053 0.3252];
bwXSigma = [0.2639 0.3514];
bwXListPReg = {bwXMu bwXSigma};
clockLocal = tic();
[hPredArray,xc] = estimateHistogramGaussian(XTrain,ZTrain,XHold,sensor,bwXList);
compTime = toc(clockLocal);
fprintf('Estimation took %.2fs\n',compTime);

%% Save to file
in.pre = '../data';
in.tag = 'exp11-ascension-modeling-preg-output';
fileName = buildDataFileName(in);
save(fileName,'hPredArray','xc','bwXList','compTime','-v7.3');

