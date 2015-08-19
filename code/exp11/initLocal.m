someUsefulPaths
addpath(genpath(pathToM))

here = pwd;
addpath([pwd '/hist_distances']);
addpath([pwd '/utils']);
addpath([pwd '/data_processors']);
addpath([pwd '/data']);
exp4Path = [here '/../exp4'];
clear here

% for kernels
addpath([exp4Path '/kernels']);
% for laser gencal simulator
addpath([exp4Path '/predictors']);
addpath([exp4Path '/input_transformers']);
addpath([exp4Path '/space_switches']);
addpath([exp4Path '/data']);
