function obj = algoObj(X,Y,params)
%ALGOOBJ 
% 
% obj = ALGOOBJ(data,params)
% 
% X      - 
% Y      - 
% params - Struct with fields ('maxErr','eps')
% 
% obj    - 

debugFlag = true;

localizer = lineMapLocalizer([]);
numIter = 200;
skip = 3;
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,...
    'skip',skip,'numIter',numIter));

nData = length(X);
errVec = zeros(1,nData);
clockLocal = tic;
for i = 1:nData
    localizer = lineMapLocalizer(X(i).map.objects);
    localizer.maxErr = params.maxErr;
    localizer.eps = params.eps;
    refiner.localizer = localizer;
    poseTrue = X(i).sensorPose;
    poseIn = X(i).perturbedPose;
    poseOut = refiner.refine(Y(i).ranges,poseIn);
    errVec(i) = pose2D.poseNorm(poseTrue,poseOut);
end

obj = mean(errVec);
tComp = toc(clockLocal);

if debugFlag
    fprintf('algoObj:Computation time: %.2fs.\n',tComp);
end
if isnan(obj)
    error('algoObj:invalidObjectiveValue','Objective is nan.');
end
if isinf(obj)
    error('algoObj:invalidObjectiveValue','Objective is inf.');
end
end