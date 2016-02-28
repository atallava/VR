% corridor walls
% north wall
wall1 = lineObject();
wall1.lines = [0 2.5; 5 2.5];

% south wall
wall2 = lineObject();
wall2.lines = [0 -2.5; 5 -2.5];

map = lineMap([wall1 wall2]);

%% save map
save('../data/wide_corridor','wall1','wall2','map');

%% specify support
support.xv = wall1.lines(:,1);
support.xv = [support.xv; flipud(wall2.lines(:,1))];
support.xv = [support.xv; wall1.lines(1,1)];

support.yv = wall1.lines(:,2);
support.yv = [support.yv; flipud(wall2.lines(:,2))];
support.yv = [support.yv; wall2.lines(1,2)];

%% save
save('../data/wide_corridor_support','support');

%% specify dynamic supports
% corresponding to north wall
support1.xv = [0 0 5 5 0];
support1.yv = [1 2.5 2.5 1 1];

% correspondig to south wall
support2.xv = [0 5 5 0 0];
support2.yv = [-1 -1 -2.5 -2.5 -1];

supports = [support1 support2];

%% save
save('../data/wide_corridor_dynamic_supports','supports');