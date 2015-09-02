in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-loss-field-dreg-input';
in.date = '150821'; 
in.index = '3';
fileName = buildDataFileName(in);
load(fileName);

%% Estimate histograms
% CHECK PARAMETERS BEFORE ESTIMATING!
% bwX = [0.01 0.01 0.01];
bwX = [0.04 0.04 0.08];
bwZ = 1e-3;
t1 = tic();
[hArray,xc] = estimateHistogram(XTrain,ZTrain,XField,sensor,bwX,bwZ);
compTime = toc(t1);
fprintf('Estimation took %.2fs\n',compTime);

