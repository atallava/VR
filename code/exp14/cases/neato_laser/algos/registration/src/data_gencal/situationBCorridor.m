wall1 = lineObject();
wall1.lines = [0 -3.672;0 0;3.672 0];
wall2 = lineObject();
wall2.lines = [-2.5 -3.346;-2.5 1.55;3.62 1.55];

refMap = lineMap([wall1 wall2]);
perturbationLims.x = [0.005 0.05];
perturbationLims.y = [0.005 0.05];
perturbationLims.th = deg2rad([-5 5]);

support = [wall1.lines; flipud(wall2.lines); wall1.lines(1,:)];

%% case 1, uncluttered
map = lineMap([wall1 wall2]);
fname = '../data/situation_b_corridor_clear';
save(fname,'map','refMap','support','perturbationLims');

%% case 2, clutter
count = 1;
clear clutter;
clutter(count) = lineObject();
clutter(count).lines = [3.89 1.87;3.89 1.68;4.29 1.71;4.29 1.85;3.87 1.85];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-3.17 -3.57;-2.68 -3.57;-2.66 -4.13;-3.27 -4.13;-3.27 -3.52];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-0.888 -2.75;-0.701 -2.75;-0.724 -2.96;-0.934 -2.94;-0.864 -2.63];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-1.45 0.988;-1.35 0.988;-1.33 0.872;-1.42 0.872;-1.4 1.01];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [4.22 0.446;4.27 -0.65;4.57 -0.627;4.57 0.353;4.22 0.376];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [1.96 0.586;2.09 0.586;2.09 0.532;1.92 0.514;1.92 0.622];
count = count+1;

map = lineMap([wall1 wall2 clutter]);

fname = '../data/situation_b_corridor_clutter';
save(fname,'map','refMap','support','perturbationLims');