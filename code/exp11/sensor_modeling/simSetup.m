% specify environment
load roomLineMap;
bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

%% get training and test poses
N = 200;
poses = uniformSamplesOnSupport(support,map,bBox,N);
NTrain = ceil(0.6*N);
NTest = N-NTrain;
trainIds = randsample(1:N,NTrain);


% specify sensor model


% simulate sensor readings

% save to file