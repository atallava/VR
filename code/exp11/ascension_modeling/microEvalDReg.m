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
pId = randsample(1:length(XHold),1);
bwX = 0.1;
bwZ = 0.05;

clockLocal = tic();
[hDReg,xc] = estimateHistogram(XTrain,ZTrain,XHold(pId),sensor,bwX,bwZ);
hGt = ranges2Histogram(ZHold(pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @(h1,h2) histDistanceMomentMatch(h1,h2,xc);
err = histDistance(hGt,hDReg);

%% visualize histogram
close all;
vizHists(hGt,hDReg,xc);
suptitle(sprintf('pose: %d',XHold(pId)));