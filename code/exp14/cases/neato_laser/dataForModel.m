% collect data for model from different algos

count = 1;

% detection
algosVars(count).dataReal = load('algos/detection/data_real_train.mat');
count = count+1;

% registration
algosVars(count).dataReal = load('algos/registration/data_real_train.mat');
count = count+1;

nAlgos = count-1;
dataModel = struct('X',{},'Y',{});
for i = 1:nAlgos
    dataModel.X = [dataModel.X algoVars(count).dataReal.X];
    dataModel.Y = [dataModel.Y algoVars(count).dataReal.Y];
end
   
% write to file somewhere