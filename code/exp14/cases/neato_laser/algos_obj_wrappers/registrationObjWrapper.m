function obj = registrationObjWrapper(data,params)

someUsefulPaths;
currentPath = pwd;
detectionPath = [pathToR1 '/code/exp14/cases/neato_laser/algos/registration'];
cd(detectionPath);
obj = f1Obj(data,params);
cd(currentPath);
end