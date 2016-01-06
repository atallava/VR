% initialize

% all length units are m
% scale for occupancy map
scaleLims = [0.005 0.08];
% probability of cell being occupied
pOccLims = [0.5 1];
algoParamsLims = {scaleLims pOccLims};
nAlgoParams = 2;
nSamples = 20;

%% uniform sampling
scaleSamples = range(scaleLims).*rand(1,nSamples)+scaleLims(1);
pOccSamples = range(pOccLims).*rand(1,nSamples)+pOccLims(1);

algoParamsSamples = struct('scale',num2cell(scaleSamples),...
    'pOcc',num2cell(pOccSamples));

%% write to file
save('data/algo_params_samples','algoParamsSamples','algoParamsLims','nSamples');


