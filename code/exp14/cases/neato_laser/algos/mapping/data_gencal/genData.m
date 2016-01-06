% generate sim data

%% load sim
someUsefulPaths;
exp4Path = [pathToR1 '/code/exp4'];
addpath(genpath(exp4Path));
load rsim_sep6_2.mat;

%% generate data
supportAreaPerPose = 0.5*0.5; % in m
X = struct('poses',{},'map',{},'mapXyLims',{});
Y = struct('ranges',{});

mapNames = {'box','l_corridor','s_corridor'};
nMaps = length(mapNames);
for i = 3%:nMaps
    % load map
    mapName = mapNames{i};
    lmStruct = load([mapName '_line_map']);
    omStruct = load([mapName '_occupancy_map'],'map','xyLims');
    load([mapName '_map_support'],'support');
    supportArea = polyarea(support.xv,support.yv);
    rsim.setMap(lmStruct.map);
    
    % sample poses
    nPoses = round(supportArea/supportAreaPerPose);
    poses = uniformSamplesOnSupport(lmStruct.map,support,robotModel.bBox,nPoses);
    
    % generate ranges
    ranges = zeros(nPoses,rsim.laser.nBearings);
    for j = 1:nPoses
        ranges(j,:) = rsim.simulate(poses(j,:));
    end
    X(i).poses = poses;
    X(i).map = omStruct.map;
    X(i).mapXyLims = omStruct.xyLims;
    Y(i).ranges = ranges;
end

%% write to file
fname = 'data_gencal';
save(fname,'X','Y');

%% throw away everything on exp4 path
rmpath(genpath(exp4Path));