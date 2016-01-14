% data: struct with fields ('X','Y')
% X: struct array with fields ('sensorPose','map','refMap')
% map is the true generating map, and ref map is what is passed to the
% localizer
% Y: struct array with fields ('ranges')

%% mapping algo params
% params: struct with fields ('maxErr','eps')
% maxErr, which decides number of outliers
% eps, the step increment in computing the jacobian