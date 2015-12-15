% train using algodev metric
% have to run initLocal

%% specify training algos 
algosTrain = {'detectn','registration'};

%% create model
% load some relevant files
inputStruct.XTrain = ;
inputStruct.YTrain = ;
inputStruct.kernelParams = struct('h',[0.1 0.1]); 
laserModel = exp14LaserModel(inputStruct);

%% train

% pick model parameter
h = [0.1 0.1];
laserModel.updateKernelParams(struct('h',h));

% simulated data
% loop over algorithms
for i = 1:length(algosTrain)
    algo = algosTrain{i};
    realDataFName = ;
    simDataFName = ;
    genSimData(laserModel,realDataFName,simDataFName);
end

% get risk for this parameter
risk = 0;
losses = zeros(1,size(algosTrain));
% loop over algorithms
for i = 1:length(algosTrain)
   algo = algosTrain{i};
   % decide functions
   losses(i) = calcLoss(realDataFName,simDataFName,calcObjAddIn);
   risk = risk+loss;
end

% iterate till local minima
% how will you iterate? relegate to matlab fmincon