% pReg pipeline for ascension modeling
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150821'; 
in.index = '2';
fileName = buildDataFileName(in);
load(fileName);

%%
bwXMu = 1;
bwXSigma = 1;
bwXList = {bwXMu bwXSigma};
clockLocal = tic();
[hPredArray,xc] = estimateHistogramGaussian(XTrain,ZTrain,XHold,sensor,bwXList);
compTime = toc(clockLocal);
fprintf('Estimation took %.2fs\n',compTime);

%% Save to file
in.pre = '../data';
in.tag = 'exp11-ascension-modeling-dreg-output';
fileName = buildDataFileName(in);
save(fileName,'hPredArray','xc','bwXList','compTime','-v7.3');

