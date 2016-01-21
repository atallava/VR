res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath(pathToM))
addpath(pathToNeatoM)

exp4Path = pwd;
addpath(exp4Path);
addpath([exp4Path '/data_collection_helpers']);
addpath([exp4Path '/data_processors']);
addpath([exp4Path '/goodness_helpers']);
addpath([exp4Path '/input_transformers']);
addpath([exp4Path '/kernels']);
addpath([exp4Path '/optimizers']);
addpath([exp4Path '/pdf_models']);
addpath([exp4Path '/predictors']);
addpath([exp4Path '/space_switches']);
addpath([exp4Path '/viz_helpers']);
