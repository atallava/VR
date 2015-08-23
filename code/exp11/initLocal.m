res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath(pathToM))

exp11Path = pwd;
addpath(exp11Path);
addpath([exp11Path '/hist_distances']);
addpath([exp11Path '/pose_sampling']);
addpath([exp11Path '/data_processors']);
addpath([exp11Path '/data']);
addpath([exp11Path '/gkde2']);

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