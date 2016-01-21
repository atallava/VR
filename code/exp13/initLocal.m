someUsefulPaths
% how do you ensure that this code is on the right git branch
addpath(genpath(pathToNeatoM));
addpath(genpath(pathToM));

here = pwd;
addpath([here '/stat_metrics/']);
clear here;

% home is where the algorithm is
addpath(genpath([pathToR1 '/code/exp4/application_detection/']))