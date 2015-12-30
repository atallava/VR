% convert data to form suitable for use in baseline training

% load files
% data pulled from exp4
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath([exp4Path '/application_detection']));

% the configurations
load data/dataset_rangenorm
% ranges
load data/scans_real
% corrupt ids
load data/corrupt_conf_ids
% target lines
load data/target_lines_by_conf

%% 
% same sensor pose for all configurations
sensorPose = [1.87; 1.97; 0];

nStates = length(confList);
X = struct('sensorPose',{},'map',{},'targetLines',{});
Y = struct('ranges',{});
obsId = 1; % there are a number of range scans, picking one
count = 1;

for i = 1:nStates
    if ismember(i,corruptIds)
        continue;
    end
    X(count).sensorPose = sensorPose;
    confList(i).createMap();
    X(count).map = confList(i).map;
    X(count).targetLines = targetLinesByConf{i};
    Y(count).ranges = scans{i}(obsId,:);
    count = count+1;
end

%% 
save('data/data_real','X','Y');
