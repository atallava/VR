% convert data to form suitable for use in baseline training

% data pulled from exp4
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath([exp4Path '/application_detection']));

% same sensor pose for all configurations
sensorPose = [1.87; 1.97; 0];
% the configurations
load dataset_rangenorm
% ranges
load scans_real
nStates = length(confList);
X = struct('sensorPose',{},'map',{});
Y = zeros(nStates,360);
obsId = 1; % there are a number of range scans, picking one
for i = 1:nStates
    X(i).sensorPose = sensorPose;
    confList(i).createMap();
    X(i).map = confList(i).map;
    Y(i,:) = scans{i}(obsId,:);
end

%% 
save('data_real','X','Y');
