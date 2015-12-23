function obj = registrationObjWrapper(data,params)

someUsefulPaths;
currentPath = pwd;
registrationPath = [pathToR1 '/code/exp14/cases/neato_laser/algos/registration'];
cd(registrationPath);
obj = algoObj(data,params);
cd(currentPath);
end