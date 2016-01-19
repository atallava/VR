walls = lineObject();
walls.lines = [0 0; 1.5 0; 1.5 3; 0 3; 0 0];

refMap = lineMap(walls);
perturbationLims.x = [0.005 0.05];
perturbationLims.y = [0.005 0.05];
perturbationLims.th = deg2rad([-5 5]);

% support is only over half the map
support = [0 0; 1.5 0; 1.5 1.5; 0 1.5; 0 0];

%% picks
count = 1;
picks(count) = lineObject();
picks(count).lines = [0.2 1.5; 0.35 1.5;];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [0.5 1.5; 0.65 1.5];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [1 1.5; 1.15 1.5];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [0.7 0.3; 0.85 0.3];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [0.15 0.15; 0.3 0.15];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [1.25 0.661;1.36 0.75];
count = count+1;

picks(count) = lineObject();
picks(count).lines = [0.842 2.31;1.02 2.3];
count = count+1;

map = lineMap([walls picks]);
fname = '../data/situation_competition_map';
save(fname,'map','refMap','support','perturbationLims');