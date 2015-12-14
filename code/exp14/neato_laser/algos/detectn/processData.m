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
x = struct('sensorPose',{},'map',{});
y = zeros(nStates,360);
obsId = 1; % there are a number of range scans, picking one
for i = 1:nStates
    x(i).sensorPose = sensorPose;
    confList(i).createMap();
    x(i).map = confList(i).map;
    y(i,:) = scans{i}(obsId,:);
end

%% 
save('data_real','x','y');
