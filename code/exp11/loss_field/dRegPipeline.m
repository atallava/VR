% dReg pipeline for loss field
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-loss-field-dreg-input';
in.date = '150821'; 
in.index = '3';
fileName = buildDataFileName(in);
load(fileName);

%% Estimate histograms
% CHECK PARAMETERS BEFORE ESTIMATING!
bwX = [0.01 0.01 0.01];
% bwX = [0.03 0.03 0.08];
% bwX = [0.001 0.0644];
bwZ = 1e-3;
t1 = tic();
[hArray,xc] = estimateHistogram(XTrain,ZTrain,XField,sensor,bwX,bwZ);
fprintf('Estimation took %.2fs\n',toc(t1));

%% Save to file
in.pre = '../data';
in.tag = 'exp11-loss-field-dreg-output';
fileName = buildDataFileName(in);
save(fileName,'hArray','xc','-v7.3');

