% initialize

% minimum points on line
nMinLims = [2 20];
% error threshold
errorThreshLims = [0.001 0.02];
algoParamsLims = {nMinLims errorThreshLims};
nAlgoParams = length(algoParamsLims);
nSamples = 20;

%% uniform sampling
nMinSamples = datasample([nMinLims(1):nMinLims(2)],nSamples);
errorThreshSamples = range(errorThreshLims).*rand(nSamples,1)+errorThreshLims(1);

algoParamsSamples = struct('nMin',num2cell(nMinSamples'),...
    'errorThresh',num2cell(errorThreshSamples));

%% write to file
save('data/algo_params_samples','algoParamsSamples','algoParamsLims','nSamples');