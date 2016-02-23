someUsefulPaths
addpath(genpath([pathToM '/neato_utils']));
addpath(genpath([pathToM '/at_utils_m']));
addpath(genpath(pathToNeatoM));

gtFactoryPath = pwd;
addpath([gtFactoryPath '/data/']);
addpath([gtFactoryPath '/utils/']);

% for interpTrajectory
addpath([gtFactoryPath '../exp8/utils']);
% to parse mocap data
addpath([gtFactoryPath '../mocap/utils']);
