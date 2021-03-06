% when i don't have the time to write a structured evaluation
in.pre = 'data';
in.source = 'ascension-tracker'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150831'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

%% estimate at one pose only
% CHECK PARAMETERS BEFORE ESTIMATING!
% pId: 31, 11 for figures
% pId = randsample(1:length(XHold),1);
pId = 1:length(XHold);
bwX = 0.1;
bwZ = 0.05;

clockLocal = tic();
[hDReg,xc] = estimateHistogram(XTrain,ZTrain,XHold(pId),sensor,bwX,bwZ);
hGt = ranges2Histogram(ZHold(pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @histDistanceMatch;
err = histDistance(hGt,hDReg);

%% visualize histogram
close all;
vizHists(hGt,hDReg,xc);
suptitle(sprintf('pose: %.2f',XHold(pId)));