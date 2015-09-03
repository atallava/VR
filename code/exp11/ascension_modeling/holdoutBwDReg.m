% select bwX on holdout data
in.pre = '../data';
in.source = 'ascension-tracker'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150831'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

%% specify bw range
nBwX = 10;
nBwZ = 10;
limsBwX = [0.1 40];
limsBwZ = [0.05 5];
[bwXArray,bwZArray] = meshgrid(linspace(limsBwX(1),limsBwX(2),nBwX),linspace(limsBwZ(1),limsBwZ(2),nBwZ));
bwXArray = bwXArray(:);
bwZArray = bwZArray(:);

%% estimate histograms
xc = getHistogramBins(sensor);
% histDistance = @(h1,h2) histDistanceMomentMatch(h1,h2,xc);
histDistance = @histDistanceMatch;
bwMeanErr = zeros(1,length(bwXArray));
hArray = ranges2Histogram(ZHold,xc);

localClock = tic();
for i = 1:length(bwXArray)
    bwX = bwXArray(i);
    bwZ = bwZArray(i);
    fprintf('i: %d, bwX %.2f, bwZ: %.2f\n ',i,bwX,bwZ);
    hPredArray = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
    [bwMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    fprintf('mean err: %.2f\n',bwMeanErr(i));
end
compTime = toc(localClock);
fprintf('Computation took %.2fs\n',compTime);

[minErr,minId] = min(bwMeanErr);
bwXOpt = bwXArray(minId); bwZOpt = bwZArray(minId);

%% save to file
in.tag = 'exp11-sensor-modeling-dreg-bw';
fname = buildDataFileName(in);
save(fname,'bwXArray','bwZArray','histDistance',...
    'bwMeanErr','bwXOpt','bwZOpt','compTime');
