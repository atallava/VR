someUsefulPaths
addpath(genpath([pathToM '/neato_utils']));
addpath(genpath([pathToM '/at_utils_m']));
addpath(genpath(pathToNeatoM));

here = pwd;
addpath([here '/data/']);
clear here

% for interpTrajectory
addpath ../exp8/utils
% to parse mocap data
addpath ../mocap/utils
