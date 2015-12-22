% generate sim data

%% load sim
% an option is to use the lightweight sim
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath(exp4Path));
load([pathToR1 '/code/sim_modular/data/sim_sep6_2.mat']);

%% load map
fNameMap = 'l_map.mat';
load(fNameMap);
rsim.setMap(map);
fNameSupport = [fNameMap '_support'];
load(fNameSupport);

%% sample poses
exp11Path = [pathToR1 '/code/exp11'];
% sampling machinery
addpath([exp11Path '/pose_sampling']);

bBox.xv = robotModel.bBox(:,1); 
bBox.yv = robotModel.bBox(:,2);

nPoses = 30;
sensorPoses = uniformSamplesOnSupport(support,map,bBox,nPoses);

%% generate range readings
ranges = zeros(nPoses,rsim.laser.nBearings);
for i = 1:nStates
    ranges(i,:) = rsim.simulate(sensorPoses(:,i));
end

X = struct('sensorPose',mat2cell(sensorPoses,3,ones(1,nStates)),...
    'map',map);
Y = struct('ranges',ranges);

%% write to file
fname = 'data_gencal';
save(fname,'X','Y');

%% remove paths
rmpath(genpath(exp4Path));
rmpath([exp11Path '/pose_sampline']);