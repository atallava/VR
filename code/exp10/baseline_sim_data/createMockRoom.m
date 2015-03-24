walls = lineObject();
walls.lines = [3 0; 1.75 0; 1.75 0.5; 1.5 0.5; 1.5 0; 0 0; ...
	0 2; 0.3 2; 0.3 2.2; 0 2.2; 0 3];
objects = walls;

%% clutter
clutter = lineObject();
clutter.lines = ...
	[1.0395    0.4605
	1.0921    0.5219
	1.1535    0.4167
	1.0833    0.3114
	0.9956    0.3728
	1.0132    0.4956];
objects = [objects clutter];

clutter = lineObject();
clutter.lines = ...
	[1.8553    1.0833
	1.7851    0.9342
	1.9518    0.7588
	2.2851    0.9167
	2.2325    1.1886
	1.8816    1.0482];
objects = [objects clutter];

clutter = lineObject();
clutter.lines = ...
	[0.2412    2.8114
	1.1974    2.5395];
objects = [objects clutter];

clutter = lineObject();
clutter.lines = ...
	[1.9079    2.1886
	2.0132    1.9693
	2.1009    2.1623
	2.0132    2.2149
	1.8991    2.0833];
objects = [objects clutter];

%% bins
bin = lineObject();
bin.lines = [-0.1 -0.15; 0.1 -0.15; 0.1 0.15; -0.1 0.15; -0.1 -0.15];

bin1 = lineObject;
bin1.lines = bsxfun(@plus,bin.lines,[0.88 1.2]);
objects = [objects bin1];
map = lineMap(objects);
save('mock_map_train','map');

objects(end) = [];
bin2 = lineObject;
bin2.lines = bsxfun(@plus,bin.lines,[1.2 1.2]);
objects = [objects bin2];

bin3 = lineObject;
bin3.lines = pose2D.transformPoints(bin.lines',[0.85; 1.8; -pi/2])';
objects = [objects bin3];
map = lineMap(objects);
save('mock_map_test','map');

