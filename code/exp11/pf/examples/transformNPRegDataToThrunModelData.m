fname = '../data/npreg_train_data';
load(fname,'XTrain','ZTrain','sensor');

%% 
% only retain nominal range
XTrain = XTrain(:,1);

% randomly sample from observations
obs = zeros(size(XTrain));
for i = 1:size(XTrain)
    obs(i) = randsample(ZTrain{i},1);
end
ZTrain = obs;

%% save
fname = '../data/thrun_model_train_data';
save(fname,'XTrain','ZTrain','sensor');
