function obj = algoObj(X,Y,params)
%ALGOOBJ 
% 
% obj = ALGOOBJ(data,params)
% 
% X      - State.
% Y      - Observation.
% params - Struct with fields ('maxErr','eps') or vector.
% 
% obj    - 

debugFlag = false;

if isnumeric(params)
   params = algoParamsVecToStruct(params); 
end

load('data/algo_misc_params','numIter','skip');
load('laser_class_object','laser');
localizer = lineMapLocalizer([]);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',laser,...
    'skip',skip,'numIterations',numIter));

nData = length(X);
errVec = zeros(1,nData);
clockLocal = tic;
for i = 1:nData
    if isfield(X(i),'refMap')
        map = X(i).refMap;
    else
        map = X(i).map;
    end
    localizer = lineMapLocalizer(map.objects);
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