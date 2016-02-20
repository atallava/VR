res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath([pathToM '/neato_utils']));
addpath(genpath([pathToM '/at_utils_m']));
addpath(genpath(pathToNeatoM));

simFactoryPath = pwd;
addpath([simFactoryPath '/data/']);

% for simulator
simModularPath = ([simFactoryPath '/../sim_modular']);
addpath(genpath(simModularPath));
% for interpTrajectory
exp8Path = [simFactoryPath '/../exp8'];
addpath([exp8Path '/utils/']);
% to parse mocap data
mocapPath = [simFactoryPath '/../mocap/'];
addpath([mocapPath '/utils/']);
% gt data files
gtFactoryPath = [simFactoryPath '/../gt_factory/'];
addpath([gtFactoryPath '/data/']);
