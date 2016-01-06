function obj = algoObj(data,params)
%ALGOOBJ 
% 
% obj = ALGOOBJ(data,params)
% 
% data   - Struct with fields ('X','Y')
% params - Struct with fields ('scale','pOcc')
% 
% obj    - 

load('laser_class_object','laser');
nData = length(data.X);

obj = 0;
objLog = zeros(1,nData);

for i = 1:nData
    poses = data.X(i).poses;
    map = data.X(i).map;
    xyLims = data.X(i).mapXyLims;
    ranges = data.Y(i).ranges;
    
    % get occupancy map
    inputStruct = struct('laser',laser,'xyLims',xyLims,...
        'scale',params.scale,'pOcc',params.pOcc);
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
    obj = obj+nll;
    
    % log
    objLog(i) = nll;
end
    
end