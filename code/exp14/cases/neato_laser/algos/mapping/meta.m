% data: struct with fields ('X','Y')
% X: struct array with fields ('poses','map','mapSize')
% Y: [nPoses,laser.nBearings] array

%% mapping algo params
% params: struct with fields ('scale','pOcc')
% maxErr, which decides number of outliers
% eps, the step increment in computing the jacobian