% initialize

% minimum points on line
NMinLims = [5 20];
% error threshold
errorThreshLims = [0.001 0.02];
algoParamsLims = {NMinLims errorThreshLims};
nAlgoParams = length(algoParamsLims);
nSamples = 100;

%% uniform sampling
randSamples = zeros(nSamples,nAlgoParams);
for i = 1:nAlgoParams
    paramLims = algoParamsLims{i};
    randSamples(:,i) = ...
        range(paramLims).*rand(nSamples,1)+paramLims(1);
end

algoParamSamples = struct('nMin',num2cell(randSamples(:,1)),...
    'errorThresh',num2cell(randSamples(:,2)));

%% write to file
save('algo_params_samples','algoParamsSamples','algoParamsLims','nSamples');


