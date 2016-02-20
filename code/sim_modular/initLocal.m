res = which('someUsefulPaths');
if isempty(res)
    error('initLocal:scriptNotFound','someUsefulPaths not found.');
end
someUsefulPaths
addpath(genpath([pathToM '/neato_utils']));
addpath(genpath([pathToM '/at_utils_m']));
addpath(pathToNeatoM);

simModularPath = pwd;
addpath([simModularPath '/']);
addpath([simModularPath '/input_modules/']);
addpath([simModularPath '/encoders_modules/']);
addpath([simModularPath '/laser_modules/']);
addpath([simModularPath '/data/']);
addpath([simModularPath '/unit_tests/']);

% for laserSimulator
% this is the speedy version
addpath([pathToVR '/../neato_laser_simulator/utils/'])
