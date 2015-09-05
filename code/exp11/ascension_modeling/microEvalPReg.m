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
pId = 11;%randsample(1:length(XHold),1);
bwXMu = 40;
bwXSigma = 40;
bwXList = {bwXMu bwXSigma};

clockLocal = tic();
[hPReg,xc] = estimateHistogramGaussian(XTrain,ZTrain,XHold(pId),sensor,bwXList);
hGt = ranges2Histogram(ZHold(pId),xc);
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% error
histDistance = @(h1,h2) histDistanceMomentMatch(h1,h2,xc);
err = histDistance(hGt,hPReg);

%% visualize histogram
close all;
vizHists(hGt,hPReg,xc);
suptitle(sprintf('pose: %.2f',XHold(pId)));