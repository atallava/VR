load ../data/nsh3_corridor.mat

refMap = lineMap([lwall rwall]);
perturbationLims.x = [0.005 0.05];
perturbationLims.y = [0.005 0.05];
perturbationLims.th = deg2rad([-5 5]);

support = [rwall.lines; flipud(lwall.lines); rwall.lines(1,:)];

%% case 1, uncluttered
map = lineMap([lwall rwall]);
fname = '../data/situation_nsh3_corridor_clear';
save(fname,'map','refMap','support','perturbationLims');

%% case 2, clutter
count = 1;
clear clutter
clutter(count) = lineObject();
clutter(count).lines = [8.5 -1.4;8.61 -1.23;8.81 -1.4;8.67 -1.57;8.53 -1.28];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-2.42 -2.59;-2.47 -3.62;-2.14 -3.62;-2.08 -2.48;-2.42 -2.56];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [2.75 1.31;2.83 1.42;2.95 1.31;2.72 1.14;2.66 1.34];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [7.16 0.343;7.25 0.371;7.25 0.258;7.16 0.286;7.16 0.428];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-1.84 1.22;-1.9 1.14;-1.78 1.05;-1.61 1.16;-1.87 1.33];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-1.05 -1.13;-0.765 -1.1;-0.765 -1.47;-1.11 -1.5;-1.02 -1.04];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [8.27 1.36;8.38 1.39;8.41 1.5;8.27 1.5;8.3 1.31];
count = count+1;

map = lineMap([rwall lwall clutter]);

fname = '../data/situation_nsh3_corridor_clutter';
save(fname,'map','refMap','support','perturbationLims');
