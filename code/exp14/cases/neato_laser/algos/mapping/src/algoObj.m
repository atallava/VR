function obj = algoObj(X,Y,params)
%ALGOOBJ Mean negLogLike over maps in data.
% 
% obj = ALGOOBJ(data,params)
% 
% X      - 
% Y      - 
% params - Struct with fields ('scale','pOcc')
% 
% obj    - Objective

debugFlag = false;

load('laser_class_object','laser');
load('data/occupancy_map_default_params','pInit','pFree');
nData = length(X);

objLog = zeros(1,nData);

clockLocal = tic;
for i = 1:nData
    poses = X(i).poses;
    map = X(i).map;
    xyLims = X(i).mapXyLims;
    ranges = Y(i).ranges;
    
    % get occupancy map
    inputStruct = struct('laser',laser,'xyLims',xyLims,...
        'scale',params.scale,'pOcc',params.pOcc,...
        'pInit',pInit,'pFree',pFree);
    om = occupancyMap(inputStruct);
    % should probably subsample ranges
    skip = 10;
    subsampledIds = 1:skip:laser.nBearings;
    om.processRanges(poses,ranges(:,subsampledIds),...
        laser.bearings(subsampledIds));
    
    % subscale to real map scale
    omScaled = om.subscaleMap(map.scale);
    
    % negloglikelihood of real map 
    binaryGridMap = map.getBinaryGrid();
    nll = omScaled.calcNegLogLike(binaryGridMap);
       
    % log
    objLog(i) = nll;
end
obj = mean(objLog);
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