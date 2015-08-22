res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath(pathToM))

exp10Path = pwd;
addpath(pwd);
addpath([exp10Path '/data']);
addpath([exp10Path '/baseline_sim_data/']);
addpath([exp10Path '/data_processors/']);

exp4Path = [exp10Path '/../exp4'];
% for baseline simulator
addpath ../exp4/predictors/
