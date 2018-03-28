% four-poster scan comparisons

%% load data
runId = 7;
load('../data/b100_padded_corridor','map');

vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser));

srcName = '../data/real_sensor_data';
load(srcName, 'sensorData');
scans = sensorData(runId).scanArray;

%% get pts
scanId = 220;
ranges = scans{scanId};

thArray = deg2rad(0:359);
xArray = ranges.*cos(thArray);
yArray = ranges.*sin(thArray);

%% viz
hfig = figure;
hold on; axis equal;
markerSize = 500;
% points
scatter(xArray, yArray, ...
    '.r', 'sizeData', markerSize);

% pose arrow
qvLen = 0.5;
lineWidth = 3;
hq = quiver(0, 0, qvLen*cos(0), qvLen*sin(0), ...
    'k','LineWidth', lineWidth); hold off;

xlim([-3 3]); ylim([-2.5 2.5]);
xlabel('x (m)'); ylabel('y (m)');
box on;

fontSize = 15;
set(gca, 'fontSize', fontSize);


