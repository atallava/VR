walls = lineObject();
walls.lines = [3 0; 0 0; 0 3];

refMap = lineMap(walls);
perturbationLims.x = [0.005 0.05];
perturbationLims.y = [0.005 0.05];
perturbationLims.th = deg2rad([-5 5]);

%% case 1, support near map
support = [0 0; 2 0; 2 2; 0 2; 0 0];
map = lineMap(walls);
save('../data/situation_l_map_1','map','refMap','support',...
    'perturbationLims');

%% case 2, support near map + clutter
support = [0 0; 2 0; 2 2; 0 2; 0 0];

clear clutter; 
count = 1;
clutter(count) = lineObject();
clutter(count).lines = [3.39 0.0491;3.36 -0.07;3.54 -0.0849;3.61 0.064;3.34 0.0491];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [2.1 -0.19;2.44 -0.19;2.44 -0.425;2.13 -0.439;2.13 -0.19];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [0.219 3.49;0.219 3.2;0.551 3.17;0.578 3.57;0.274 3.56];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [-0.853 3.02;-0.481 3.03;-0.481 2.53;-0.838 2.53;-0.808 3.09];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [0.606 2.29;0.754 2.39;0.844 2.24;0.769 2.15;0.665 2.38];
count = count+1;

clutter(count) = lineObject();
clutter(count).lines = [2.68 1.1;2.82 1.13;2.89 0.96;2.74 0.974;2.77 1.11];
count = count+1;

map = lineMap([walls clutter]);
save('../data/situation_l_map_2','map','refMap','support',...
    'perturbationLims');

%% case 2, support far from map
support = [1.5 1.5; 4 1.5; 4 4; 1.5 4; 1.5 1.5];
map = lineMap(walls);
save('../data/situation_l_map_3','map','refMap','support',...
    'perturbationLims');

%% case 3, support far from map + clutter
support = [1.5 1.5; 4 1.5; 4 4; 1.5 4; 1.5 1.5];
map = lineMap([walls clutter]);
save('../data/situation_l_map_4','map','refMap','support',...
    'perturbationLims');

