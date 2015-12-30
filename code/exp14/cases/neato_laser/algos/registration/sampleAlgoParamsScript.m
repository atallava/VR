% initialize

% all length units are m
% maximum error for inliers before refinement
maxErrLims = [0.005 5]; 
% delta for jacobian calculation
epsScaleLims = [0.0005 0.05];
load('data/algo_param_eps_vector','eps0');
algoParamsLims = {maxErrLims epsScaleLims};
nAlgoParams = 2;
nSamples = 20;

%% uniform sampling
maxErrSamples = range(maxErrLims).*rand(1,nSamples)+maxErrLims(1);
epsScaleSamples = range(epsScaleLims).*rand(1,nSamples,1)+epsScaleLims(1);
epsSamples = bsxfun(@times,repmat(eps0,1,nSamples),epsScaleSamples);

algoParamsSamples = struct('maxErr',num2cell(maxErrSamples),...
    'eps',mat2cell(epsSamples,3,ones(1,nSamples)));

%% write to file
save('data/algo_params_samples','algoParamsSamples','algoParamsLims','nSamples');


