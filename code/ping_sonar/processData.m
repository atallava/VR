% process ping data

% load map
load ping_map

%% specify pose transform
xyOffset1 = [0.14; 0.06];
xyOffset2 = [0.12; 0.06];

%% load data set 
load set1.mat
% going to be untidy because there are two datasets which have to be merged
% into 1
poses1 = poseHistory;
poses1 = bsxfun(@plus,poses1,[xyOffset1; 0]);
obsArray1 = pingRanges2ObsArray(pingRanges);

%%
load set2
poses2 = poseHistory;
poses2 = bsxfun(@plus,poses2,[xyOffset2; 0]);
obsArray2 = pingRanges2ObsArray(pingRanges);

%%
poses = [poses1 poses2];
obsArray = [obsArray1; obsArray2];

frac = 0.7;
N = size(poses,2);
NTrain = ceil(frac*N);
NHold = ceil((N-NTrain)*0.5);
NTest = N-(NTrain+NHold);
trainIds = randsample(1:N,NTrain);
holdIds = randsample(setdiff(1:N,trainIds),NHold);
testIds = setdiff(1:N,union(trainIds,holdIds));

%%
xc = 0:300;
h = ranges2Histogram(obsArray,xc);

%%
id = randsample(size(h,1),1);
bar(xc,h(id,:));
title(sprintf('id: %d',id));