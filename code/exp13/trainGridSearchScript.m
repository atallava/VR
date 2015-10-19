% Search for a good simulator using naive grid search.
algoName = 'detection';
dirname = ['./algo_' algoName]; addpath(dirname);
% cd(dirname); specifySimSearchVariables; cd('../');
fname = ['algo_' algoName '/sim_train_variables.mat']; load(fname);

%% Metric calculation.
% For each algorithm and each simulator.
numS = length(simDataset);
numA = length(trainParamList);
metricValues = zeros(numA,numS);
statReal = zeros(1,numA);
statSim = zeros(numA,numS);
statMetric = @(x,y) norm(x-y); % pick metric
for i = 1:numA
	statReal(i) = algoStat(algoTemplate,trainParamList(i),realDataset);
	for j = 1:numS
		statSim(i,j) = algoStat(algoTemplate,trainParamList(i),simDataset{j});
		metricValues(i,j) = statMetric(statReal(i),statSim(i,j));
	end
end

%% Pick simulator.
[~,bestId] = min(max(metricValues,[],1));
save(['algo_' algoName '/train_metric_values.mat'],'statReal','statSim','metricValues');

%% Clear path
rmpath(['./algo_' algoName]);
