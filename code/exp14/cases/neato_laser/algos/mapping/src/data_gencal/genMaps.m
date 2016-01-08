% simple maps
% specify line map
% specify support
% create occ map from line map

%% scale of ground truth maps
scaleGroundTruth = 0.005;
save('scale_ground_truth','scaleGroundTruth');

%% box map
walls = lineObject();
walls.lines = [0 0; 2.5 0; 2.5 2.5; 0 2.5; 0 0];
supportPts = walls.lines;
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
lm = lineMap(walls);
omXyLims = mapXyLimsFromPolygon(support,0.5);
om = lineMapToOccupancyMap(lm,scaleGroundTruth,omXyLims);

% save
mapName = 'box';
lmStruct.map = lm;
lmStruct.walls = walls;
save([mapName '_line_map'],'-struct','lmStruct');
save([mapName '_map_support'],'support');
omStruct.map = om;
omStruct.xyLims = omXyLims;
save([mapName '_occupancy_map'],'-struct','omStruct');

%% l-corridor
wall1 = lineObject();
wall1.lines = [1 0; 1 3; 4 3];
wall2 = lineObject();
wall2.lines = [0 0; 0 4; 4 4];
supportPts = [wall1.lines; flipud(wall2.lines); 1 0];
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
lm = lineMap([wall1 wall2]);
omXyLims = mapXyLimsFromPolygon(support,0.5);
om = lineMapToOccupancyMap(lm,scaleGroundTruth,omXyLims);

% save
mapName = 'l_corridor';
lmStruct.map = lm;
lmStruct.wall1 = wall1;
lmStruct.wall2 = wall2;
save([mapName '_line_map'],'-struct','lmStruct');
save([mapName '_map_support'],'support');
omStruct.map = om;
omStruct.xyLims = omXyLims;
save([mapName '_occupancy_map'],'-struct','omStruct');

%% s-corridor
wall1 = lineObject();
wall1.lines = [1 0; 1 3; 4 3; 4 6];
wall2 = lineObject();
wall2.lines = [0 0; 0 4; 3 4; 3 6];
supportPts = [wall1.lines; flipud(wall2.lines); 1 0];
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
lm = lineMap([wall1 wall2]);
omXyLims = mapXyLimsFromPolygon(support,0.5);
om = lineMapToOccupancyMap(lm,scaleGroundTruth,omXyLims);

% save
mapName = 's_corridor';
lmStruct.map = lm;
lmStruct.wall1 = wall1;
lmStruct.wall2 = wall2;
save([mapName '_line_map'],'-struct','lmStruct');
save([mapName '_map_support'],'support');
omStruct.map = om;
omStruct.xyLims = omXyLims;
save([mapName '_occupancy_map'],'-struct','omStruct');
