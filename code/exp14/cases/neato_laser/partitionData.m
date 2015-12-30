% partition data into train, holdout and test
% load data
fname = 'algos/detection/data/data_real';
data = load(fname);

%% Partition.
nData = length(data.X);
nHold = ceil(0.2*nData);
nTest = ceil(0.2*nData);
nTrain = nData-nHold-nTest;

trainIds = randsample(1:nData,nTrain);
holdIds = randsample(setdiff(1:nData,trainIds),nHold);
testIds = setdiff(1:nData,union(holdIds,trainIds));

dataTrain.X = data.X(trainIds);
dataTrain.Y = data.Y(trainIds);
dataHold.X = data.X(holdIds);
dataHold.Y = data.Y(holdIds);
dataTest.X = data.X(testIds);
dataTest.Y = data.Y(testIds);

%% Save.
save([fname '_train'],'-struct','dataTrain');
save([fname '_hold'],'-struct','dataHold');
save([fname '_test'],'-struct','dataTest');


