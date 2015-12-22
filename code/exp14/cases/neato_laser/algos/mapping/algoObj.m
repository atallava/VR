function obj = algoObj(data,params)
%ALGOOBJ 
% 
% obj = ALGOOBJ(data,params)
% 
% data   - Struct with fields ('X','Y')
% params - Struct with fields ('maxErr','eps')
% 
% obj    - 

localizer = lineMapLocalizer([]);
numIter = 200;
skip = 3;
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,...
    'skip',skip,'numIter',numIter));

nData = length(data.X);
errVec = zeros(1,nData);
for i = 1:nData
    localizer = lineMapLocalizer(data.X(i).map.objects);
    localizer.maxErr = params.maxErr;
    localizer.eps = params.eps;
    refiner.localizer = localizer;
    poseIn = data.X(i).perturbedPose;
    poseOut = refiner(poseIn,data.Y(i,:),params);
    errVec(i) = pose2D.poseNorm(poseIn,poseOut);
end

obj = mean(errVec);
    
end