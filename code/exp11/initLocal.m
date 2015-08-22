res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath(pathToM))

exp11Path = pwd;
addpath(pwd);
addpath([pwd '/hist_distances']);
addpath([pwd '/pose_sampling']);
addpath([pwd '/data_processors']);
addpath([pwd '/data']);

exp4Path = [exp11Path '/../exp4'];
% for kernels
addpath([exp4Path '/kernels']);
% for laser gencal simulator
addpath([exp4Path '/predictors']);
addpath([exp4Path '/input_transformers']);
addpath([exp4Path '/space_switches']);
addpath([exp4Path '/data']);
addpath([exp4Path '/pdf_models']);
% for visualization
addpath([exp4Path '/viz_helpers']);

exp10Path = [exp11Path '/../exp10'];
% for occ map
addpath(exp10Path);