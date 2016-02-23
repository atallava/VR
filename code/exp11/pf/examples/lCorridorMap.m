% corridor walls
wall1 = lineObject();
wall1.lines = [-1.5 -2.5; -1.5 2.5; 4 2.5];

wall2 = lineObject();
wall2.lines = [1.5 -2.5; 1.5 1; 4 1];

map = lineMap([wall1 wall2]);

%% save map
save('l_corridor','wall1','wall2','map');

%% specify support
support.xv = wall1.lines(:,1);
support.xv = [support.xv; flipud(wall2.lines(:,1))];
support.xv = [support.xv; wall1.lines(1,1)];

support.yv = wall1.lines(:,2);
support.yv = [support.yv; flipud(wall2.lines(:,2))];
support.yv = [support.yv; wall2.lines(1,2)];

%% save support
save('l_corridor_support','support');