% simple maps

%% box map
walls = lineObject();
walls.lines = [0 0; 2.5 0; 2.5 2.5; 0 2.5; 0 0];
supportPts = walls.lines;
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
map = lineMap(walls);
fname = 'box_map';
save(fname,'map','walls');
save([fname '_support'],'support');

%% l-corridor
wall1 = lineObject();
wall1.lines = [1 0; 1 3; 4 3];
wall2 = lineObject();
wall2.lines = [0 0; 0 4; 4 4];
supportPts = [wall1.lines; flipud(wall2.lines); 1 0];
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
map = lineMap([wall1 wall2]);
fname = 'l_corridor_map';
save(fname,'map','wall1','wall2');
save([fname '_support'],'support');

%% s-corridor
wall1 = lineObject();
wall1.lines = [1 0; 1 3; 4 3; 4 6];
wall2 = lineObject();
wall2.lines = [0 0; 0 4; 3 4; 3 6];
supportPts = [wall1.lines; flipud(wall2.lines); 1 0];
support = struct('xv',supportPts(:,1),'yv',supportPts(:,2));
map = lineMap([wall1 wall2]);
fname = 's_corridor_map';
save(fname,'map','wall1','wall2');
save([fname '_support'],'support');

