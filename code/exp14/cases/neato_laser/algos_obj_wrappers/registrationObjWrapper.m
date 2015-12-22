function obj = registrationObjWrapper(data,params)

someUsefulPaths;
currentPath = pwd;
detectionPath = [pathToR1 '/code/exp14/cases/neato_laser/algos/registration'];
cd(detectionPath);
obj = algoObj(data,params);
cd(currentPath);
end