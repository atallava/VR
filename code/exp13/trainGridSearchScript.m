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
statMetric = @(x,y) norm(x-y); % pick metric
for i = 1:numA
	statReal = algoStat(algoTemplate,trainParamList(i),realDataset);
	for j = 1:numS
		statSim = algoStat(algoTemplate,trainParamList(i),simDataset{j});
		metricValues(i,j) = statMetric(statReal,statSim);
	end
end

%% Pick simulator.
% Determine best simulator. Perhaps write to file
[~,bestId] = min(max(metricValues,1));
rmpath(['./algo_' algoName]);
save(['algo_' algoName '/metricValues.mat','metricValues');