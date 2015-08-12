% specify variables
load scans_real
realDataset = scans;
load scans_baseline
simDataset{1} = scans;
load scans_sim_sep6_1
simDataset{2} = scans;

algoTemplate = []; 
limNMin = [5 20];
numNMin = 6;
nMinVals = linspace(limNMin(1),limNMin(2),numNMin);
limErrorThresh = [0.001 0.02];
numErrorThresh = 6;
errorThreshVals = linspace(limErrorThresh(1),limErrorThresh(2),numErrorThresh);
[x,y] = meshgrid(nMinVals,errorThreshVals);
x = reshape(x,1,numel(x));
y = reshape(y,1,numel(y));
nParamList = length(x);
paramList(nParamList).nMin = 0;
paramList(nParamList).errorThresh = 0;
for i = 1:nParamList;
	paramList(i).nMin = x(i);
	paramList(i).errorThresh = y(i);
end
nTrain = ceil(0.7*nParamList);
trainIds = randsample(1:nParamList,nTrain);
trainParamList = paramList(trainIds);
testIds = setdiff(1:nParamList,trainIds);
testParamList = paramList(testIds);

algoStat = @f1ScoreWrapper;

%% write
save('sim_train_variables.mat','realDataset','simDataset','algoTemplate','trainParamList','algoStat');
save('sim_test_variables.mat','realDataset','simDataset','algoTemplate','testParamList','algoStat');

