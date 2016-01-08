% to identify corrupt data

% data pulled from exp4
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath([exp4Path '/application_detection']));

% same sensor pose for all configurations
sensorPose = [1.87; 1.97; 0];
% the configurations
load ../dataset_rangenorm
% ranges
load ../scans_real
nStates = length(confList);

obsId = 1; % there are a number of range scans, picking one
for i = 1:nStates
    confList(i).createMap();
    vizer = vizRangesOnMap(struct('map',confList(i).map));
    vizer.viz(scans{i}(obsId,:),sensorPose);
    print(sprintf('figs\\conf_%02d',i),'-dpng');
    set(gcf,'visible','off');
    clear vizer;
end
