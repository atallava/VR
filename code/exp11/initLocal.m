someUsefulPaths
addpath(genpath(pathToM))

here = pwd;
addpath([pwd '/hist_distances']);
addpath([pwd '/utils']);
addpath([pwd '/data_processors']);
addpath([pwd '/data']);
exp4path = [here '/../exp4'];
delete here

% for kernels
exp4Path = 
addpath ../exp4/kernels/
% why are these needed?
% addpath ../exp4/data_processors/
% addpath ../exp4/input_transformers

