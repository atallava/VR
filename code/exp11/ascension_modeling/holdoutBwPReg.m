% select bwX on holdout data
in.pre = '../data';
in.source = 'ascension-tracker'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150831'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

%% specify bw range
nBwXMu = 10;
nBwXSigma = 10;
limsBwXMu = [0.1 40];
limsBwXSigma = [0.1 40];
[bwXMuArray,bwXSigmaArray] = meshgrid(linspace(limsBwXMu(1),limsBwXMu(2),nBwXMu),linspace(limsBwXSigma(1),limsBwXSigma(2),nBwXSigma));
bwXMuArray = bwXMuArray(:);
bwXSigmaArray = bwXSigmaArray(:);

%% estimate histograms
xc = getHistogramBins(sensor);
% histDistance = @(h1,h2) histDistanceMomentMatch(h1,h2,xc);
histDistance = @histDistanceMatch;
bwMeanErr = zeros(1,length(bwXMuArray));
[hArray,xc] = ranges2Histogram(ZHold,xc);

localClock = tic();
for i = 1:length(bwXMuArray)
    bwXMu = bwXMuArray(i);
    bwXSigma = bwXSigmaArray(i);
    bwXList = {bwXMu bwXSigma};
    fprintf('i: %d, bwX %.2f, bwZ: %.2f\n ',i,bwXMu,bwXSigma);
    hPredArray = estimateHistogramGaussian(XTrain,ZTrain,XHold,sensor,bwXList);
    [bwMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    fprintf('mean err: %.2f\n',bwMeanErr(i));
end
compTime = toc(localClock);
fprintf('Computation took %.2fs\n',compTime);

[minErr,minId] = min(bwMeanErr);
bwXMuOpt = bwXMuArray(minId); bwXSigmaOpt = bwXSigmaArray(minId);

%% save to file
in.tag = 'exp11-sensor-modeling-preg-bw';
fname = buildDataFileName(in);
save(fname,'bwXMuArray','bwXSigmaArray','histDistance',...
    'bwMeanErr','bwXMuOpt','bwXSigmaOpt','compTime');
