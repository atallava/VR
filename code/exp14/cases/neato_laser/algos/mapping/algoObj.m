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
    mapSize = data.X(i).mapSize;
    ranges = data.Y(i).ranges;
    
    % get occupancy map
    inputStruct = struct('laser',laser,'mapSize',mapSize,...
        'scale',params.scale,'pOcc',params.pOcc);
    om = occupancyMap(inputStruct);
    om.processRanges(poses,ranges);
    
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