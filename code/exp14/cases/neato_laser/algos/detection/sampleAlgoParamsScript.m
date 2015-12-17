% initialize

% minimum points on line
NMinLims = [5 20];
% error threshold
errorThreshLims = [0.001 0.02];
algoParamsLims = {NMinLims errorThreshLims};
nAlgoParams = length(algoParamsLims);
nSamples = 100;
algoParamsSamples = zeros(nSamples,nAlgoParams);

%% uniform sampling
for i = 1:nAlgoParams
    paramLims = algoParamsLims{i};
    algoParamsSamples(:,i) = ...
        range(paramLims).*rand(nSamples,1)+paramLims(1);
end

%% write to file
save('algo_params_samples','algoParamsSamples','algoParamsLims','nSamples');


