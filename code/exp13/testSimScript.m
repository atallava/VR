% Test a simulator's performance.
algoName = 'detection';
dirname = ['./algo_' algoName]; addpath(dirname);
% cd(dirname); specifySimSearchVariables; cd('../');
fname = ['algo_' algoName '/sim_test_variables.mat']; load(fname);

%% Metric calculation.
% For each algorithm and each simulator.
numS = length(simDataset);
numA = length(testParamList);
metricValues = zeros(numA,numS);
statReal = zeros(1,numA);
statSim = zeros(numA,numS);
statMetric = @(x,y) norm(x-y); % pick metric
for i = 1:numA
	statReal(i) = algoStat(algoTemplate,testParamList(i),realDataset);
	for j = 1:numS
		statSim(i,j) = algoStat(algoTemplate,testParamList(i),simDataset{j});
		metricValues(i,j) = statMetric(statReal(i),statSim(i,j));
	end
end

%%
rmpath(['./algo_' algoName]);
save(['algo_' algoName '/test_metric_values.mat'],'statReal','statSim','metricValues');