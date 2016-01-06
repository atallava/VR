% init
% load data
fname = 'data_gencal/data_gencal';
data = load(fname);

% algo params
load('data/occupancy_map_default_params','pInit','pFree');
scale = 0.05;
pOcc = 0.7;

% laser
load('laser_class_object','laser');

%% test algo
vizFlag = true;
steppingFlag = 1; % use with viz when stepping through data
nData = length(data.X);
objLog = zeros(1,nData);

for i = 1:nData
    poses = data.X(i).poses;
    map = data.X(i).map;
    xyLims = data.X(i).mapXyLims;
    ranges = data.Y(i).ranges;
    
    % get occupancy map
    inputStruct = struct('laser',laser,'xyLims',xyLims,...
        'scale',scale,'pOcc',pOcc,...
        'pInit',pInit,'pFree',pFree);
    om = occupancyMap(inputStruct);
    % should probably subsample ranges
    skip = 10;
    subsampledIds = 1:skip:laser.nBearings;
    om.processRanges(poses,ranges(:,subsampledIds),...
        laser.bearings(subsampledIds));
    
    % subscale to real map scale
    omScaled = om.subscaleMap(map.scale);
    
    if vizFlag
        hf1 = omScaled.plotGrid();
        hf2 = map.plotGrid();
        if steppingFlag
            waitforbuttonpress;
            close(hf1); close(hf2);
        end
    end
    
    % negloglikelihood of real map 
    binaryGridMap = map.getBinaryGrid();
    nll = omScaled.calcNegLogLike(binaryGridMap);
      
    % log
    objLog(i) = nll;
end

obj = mean(objLog);