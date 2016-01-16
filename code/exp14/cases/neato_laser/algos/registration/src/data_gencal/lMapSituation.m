walls = lineObject();
walls.lines = [3 0; 0 0; 0 3];

refMap = lineMap(walls);
perturbationLims.x = [0.005 0.05];
perturbationLims.y = [0.005 0.05];
perturbationLims.th = deg2rad([-5 5]);

%% case 1, support near map
support = [0 0; 1.5 0; 1.5 1.5; 0 1.5; 0 0];
map = lineMap(walls);
save('data/situation_l_map_1','map','refMap','support',...
    'perturbationLims');

%% case 2, support near map + clutter
support = [0 0; 1 0; 1 1; 0 1; 0 0];

clear clutter; 
count = 1;
clutter(count) = lineObject();
clutter(count).lines = [1.58 0.126; 1.72 0.138; 1.74 -0.0328; 1.59 -0.0441;...
1.59 0.183];
count = count+1;
clutter(count) = lineObject();
clutter(count).lines = [-0.19 1.9; -0.156 1.5; -0.287 1.51;...
-0.31 1.88; -0.168 1.88];
count = count+1;
clutter(count) = lineObject();
clutter(count).lines = [0.238 1.03; 0.399 1.05; 0.422 0.965;...
0.238 0.969; 0.281 1.08];
count = count+1;
clutter(count) = lineObject();
clutter(count).lines = [1.21 0.564; 1.27 0.576; 1.27 0.576;...
1.27 0.521; 1.22 0.521; 1.21 0.576];
count = count+1;
clutter(count) = lineObject();
clutter(count).lines = [-0.401 0.705; -0.162 0.754; -0.144 0.564;...
-0.315 0.521; -0.34 0.772];
count = count+1;
clutter(count) = lineObject();
clutter(count).lines = [1.02 -0.387; 1.15 -0.387; 1.17 -0.457;...
0.989 -0.469; 1 -0.316];

map = lineMap([walls clutter]);
% save('data/situation_l_map_2','map','refMap','support',...
%     'perturbationLims');

%% case 2, support far from map
support = 

%% case 3, support far from map + clutter

