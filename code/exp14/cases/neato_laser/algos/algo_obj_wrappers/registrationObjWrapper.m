function obj = registrationObjWrapper(X,Y,algoParams)

someUsefulPaths;
currentPath = pwd;
registrationPath = [pathToR1 '/code/exp14/cases/neato_laser/algos/registration/src'];
cd(registrationPath);
obj = algoObj(X,Y,algoParams);
cd(currentPath);
end