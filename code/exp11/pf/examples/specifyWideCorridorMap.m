% corridor walls
% left wall
wall1 = lineObject();
wall1.lines = [-2.5 0; -2.5 3];


% right wall
wall2 = lineObject();
wall2.lines = [2.5 0; 2.5 3];

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
save('../data/l_corridor_support','support');

%% specify dynamic supports
% corresponding to left wall
support1.xv = [-1.5 -1.5 4 4 -1 -1 -1.5];
support1.yv = [-2.5 2.5 2.5 2 2 -2.5 -2.5];

% correspondig to right wall
support2.xv = [1 1 4 4 1.5 1.5 1];
support2.yv = [-2.5 1.5 1.5 1 1 -2.5 -2.5];

supports = [support1 support2];

%% save
save('../data/l_corridor_dynamic_supports','supports');