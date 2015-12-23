% data for laser model from different algos

algosVars = struct('dataReal',{},'algoObj',{},'paramsSamples',{});
count = 1;

% detection
algosVars(count).dataReal = load('algos/detection/data_real_train.mat');
count = count+1;

% registration
algosVars(count).dataReal = load('algos/registration/data_gencal/data_gencal_train.mat');
count = count+1;

nAlgos = count-1;
dataModel.X = []; dataModel.Y = [];
for i = 1:nAlgos
    X = algosVars(i).dataReal.X;
    X = retainStructFields(X,{'sensorPose','map'});
    Y = algosVars(i).dataReal.Y;
    Y = retainStructFields(Y,{'ranges'});
    dataModel.X = [dataModel.X X];
    dataModel.Y = [dataModel.Y Y];
end

dataModel.laser = laserClass(struct());
   
%% Save to file.
save('data/data_laser_model','-struct','dataModel');