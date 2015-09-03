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
pId = 10%randsample(1:length(XHold),1);
bwX = 2;
bwZ = 0.01;

clockLocal = tic();
[hDReg,xc] = estimateHistogram(XTrain,ZTrain,XHold(pId),sensor,bwX,bwZ);
[hGt,xc] = ranges2Histogram(ZHold(pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @histDistanceKL;
err = histDistance(hGt,hDReg);

%% visualize histogram
close all;
vizHists(hGt,hDReg,xc);
suptitle(sprintf('pose: %d',XHold(pId)));