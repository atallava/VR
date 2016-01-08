function obj = algoObj(data,params)
%ALGOOBJ 
% 
% obj = ALGOOBJ(data,params)
% 
% data   - Struct with fields ('X','Y')
% params - Struct with fields ('maxErr','eps')
% 
% obj    - 

debugFlag = true;

localizer = lineMapLocalizer([]);
numIter = 200;
skip = 3;
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,...
    'skip',skip,'numIter',numIter));

nData = length(data.X);
errVec = zeros(1,nData);
clockLocal = tic;
for i = 1:nData
    localizer = lineMapLocalizer(data.X(i).map.objects);
    localizer.maxErr = params.maxErr;
    localizer.eps = params.eps;
    refiner.localizer = localizer;
    poseTrue = data.X(i).sensorPose;
    poseIn = data.X(i).perturbedPose;
    poseOut = refiner.refine(data.Y(i).ranges,poseIn);
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