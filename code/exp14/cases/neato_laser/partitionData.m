% partition data into train, holdout and test
% load data
fname = 'data_gencal_2';
load(fname,'dataset');

%% partition
originalDataset = dataset;
nData = length(dataset);
nHold = ceil(0.2*nData);
nTest = ceil(0.2*nData);
nTrain = nData-nHold-nTest;

trainIds = randsample(1:nData,nTrain);
holdIds = randsample(setdiff(1:nData,trainIds),nHold);
testIds = setdiff(1:nData,union(holdIds,trainIds));

%% save
dataset = originalDataset(trainIds);
save([fname '_train'],'dataset');

dataset = originalDataset(holdIds);
save([fname '_hold'],'dataset');

dataset = originalDataset(testIds);
save([fname '_test'],'dataset');
