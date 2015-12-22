% data: struct with fields ('X','Y')
% X: struct array with fields ('sensorPose','map')
% Y: [nX,laser.nBearings] array

%% mapping algo params
% params: struct with fields ('maxErr','eps')
% maxErr, which decides number of outliers
% eps, the step increment in computing the jacobian