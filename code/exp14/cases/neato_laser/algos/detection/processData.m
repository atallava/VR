% convert data to form suitable for use in baseline training

% load files
% data pulled from exp4
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath([exp4Path '/application_detection']));

% the configurations
load dataset_rangenorm
% ranges
load scans_real
% corrupt ids
load corrupt_conf_ids

%% 
% same sensor pose for all configurations
sensorPose = [1.87; 1.97; 0];

nStates = length(confList);
X = struct('sensorPose',{},'map',{});
Y = struct('ranges',{});
obsId = 1; % there are a number of range scans, picking one
count = 1;

for i = 1:nStates
    if ismember(i,corruptIds)
        continue;
    end
    X(count).sensorPose = sensorPose;
    confList(count).createMap();
    X(count).map = confList(count).map;
    Y(count).ranges = scans{count}(obsId,:);
    count = count+1;
end

%% 
save('data_real','X','Y');
