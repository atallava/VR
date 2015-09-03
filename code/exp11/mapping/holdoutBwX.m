% select bwX on holdout data
in.pre = '../data';
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-mapping-dreg-input';
in.date = '150821'; 
in.index = '4';
fname = buildDataFileName(in);
load(fname);

%% specify bw range
% CHECK PARAMETERS BEFORE ESTIMATING!
bwZ = 1e-3;
n1 = 10;
n3 = 3;
lims1 = [0.05 0.2];
lims3 = deg2rad([1 3]);
[x1Array,x3Array] = meshgrid(linspace(lims1(1),lims1(2),n1),linspace(lims3(1),lims3(2),n3));
x1Array = x1Array(:);
x2Array = x1Array(:);
x3Array = x3Array(:);

for i = 1:length(x1Array);
    bwXList{i} = [x1Array(i) x2Array(i) x3Array(i)];
%     bwXList{i} = [x1Array(i) x3Array(i)];
end

%% estimate histograms
xc = getHistogramBins(sensor);
histDistance = @(h1,h2) histDistanceMomentMatch(h1,h2,xc);
bwXMeanErr = zeros(1,length(bwXList));
hArray = ranges2Histogram(ZHold,xc);

localClock = tic();
for i = 1:length(bwXList)
    bwX = bwXList{i};
    fprintf('bwX %d:', i); disp(bwX); fprintf('\n');
    hPredArray = estimateHistogram(XTrain,ZTrain,XHold,sensor,bwX,bwZ);
    [bwXMeanErr(i),err] = evalHPred(hArray,hPredArray,histDistance);
    fprintf('mean err: %.2f\n',bwXMeanErr(i));
end
compTime = toc(localClock);
fprintf('Computation took %.2fs\n',compTime);

[minErr,minId] = min(bwXMeanErr);
bwXOpt = bwXList{minId};

%% save to file
in.tag = 'exp11-mapping-dreg-bwX';
fname = buildDataFileName(in);

%%
save(fname,'bwZ','bwXList','histDistance',...
    'bwXMeanErr','bwXOpt','compTime');
