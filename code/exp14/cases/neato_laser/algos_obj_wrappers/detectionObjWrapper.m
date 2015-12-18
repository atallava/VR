function obj = detectionObjWrapper(data,params)
%DETECTIONOBJWRAPPER 
% 
% obj = DETECTIONOBJWRAPPER(data,params)
% 
% data   - 
% params - 
% 
% obj    - 

someUsefulPaths;
currentPath = pwd;
detectionPath = [pathToR1 '/code/exp14/cases/neato_laser/algos/detection'];
cd(detectionPath);
obj = f1Obj(data,params);
cd(currentPath);
end