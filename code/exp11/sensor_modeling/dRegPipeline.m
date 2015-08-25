% dReg pipeline for loss field
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150821'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

%% Estimate histograms
% CHECK PARAMETERS BEFORE ESTIMATING!
bwX = [0.001 0.0644];
bwZ = 1e-3;
clockLocal = tic();
[hPredArray,xc] = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
compTime = toc(clockLocal);
fprintf('Estimation took %.2fs\n',compTime);

%% Save to file
in.pre = '../data';
in.tag = 'exp11-sensor-modeling-dreg-output';
fileName = buildDataFileName(in);
save(fileName,'hPredArray','xc','bwX','bwZ','compTime','-v7.3');

