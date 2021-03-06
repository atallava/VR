% select bwX on holdout data
in.source = 'neato-laser'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '140906'; 
in.index = '';
fname = buildDataFileName(in);
load(fname);

ids = randsample(1:length(ZTrain),1e4);
XTrain = XTrain(ids,:);
ZTrain = ZTrain(ids,:);

%% specify bw range
nBwX1 = 5;
nBwX2 = 2;
limsBwX1 = [0.001 0.1];
limsBwX2 = [0.0175 0.0873];
[bwX1Array,bwX2Array] = meshgrid(linspace(limsBwX1(1),limsBwX1(2),nBwX1),linspace(limsBwX2(1),limsBwX2(2),nBwX2));
bwX1Array = bwX1Array(:);
bwX2Array = bwX2Array(:);

%% estimate histograms
xc = getHistogramBins(sensor);
histDistance = @histDistanceMatch;
bwMeanErr = zeros(1,length(bwX1Array)^2);
hArray = ranges2Histogram(ZHold,xc);
bwZ = 1e-3;

count = 1;
localClock = tic();
for i = 1:length(bwX1Array)
    for j = 1:length(bwX1Array)
        bwXList = {[bwX1Array(i) bwX2Array(i)], ...
            [bwX1Array(j) bwX2Array(j)]};
        hPredArray = estimateHistogramGaussian(XTrain,ZTrain,XHold,sensor,bwXList);
        [bwMeanErr(count),err] = evalHPred(hArray,hPredArray,histDistance);
        fprintf('mean err: %.2f\n',bwMeanErr(count));
        count = count+1;
    end
end
compTime = toc(localClock);
fprintf('Computation took %.2fs\n',compTime);

[minErr,minId] = min(bwMeanErr);
bwX1Opt = bwX1Array(minId); bwX2Opt = bwX2Array(minId);

%% save to file
in.tag = 'exp11-sensor-modeling-dreg-bw';
fname = buildDataFileName(in);
save(fname,'bwX1Array','bwX2Array','histDistance',...
    'bwMeanErr','bwX1Opt','bwX2Opt','compTime');
