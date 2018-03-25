% for a figure which depicts non-idealities in real sensor data

%% load data
runId = 7;
load('../data/b100_padded_corridor','map');

vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser));

srcName = '../data/real_sensor_data';
load(srcName, 'sensorData');
scans = sensorData(runId).scanArray;

%% get pts
scanId = 6;
ranges = scans{scanId};

thArray = deg2rad(0:359);
xArray = ranges.*cos(thArray);
yArray = ranges.*sin(thArray);

%% viz
hfig = figure;
hold on;
markerSize = 500;
% points
scatter(xArray, yArray, ...
    '.r', 'sizeData', markerSize);

% pose arrow
qvLen = 0.5;
lineWidth = 3;
hq = quiver(0, 0, qvLen*cos(0), qvLen*sin(0), ...
    'k','LineWidth', lineWidth); hold off;

xlim([-3 3]); ylim([-3 3]);
xlabel('x (m)'); ylabel('y (m)');
box on;

fontSize = 15;
set(gca, 'fontSize', fontSize);

%% viz inset
hfig = figure;
hold on;
markerSize = 500;
% points
scatter(xArray, yArray, ...
    '.r', 'sizeData', markerSize);

xlim([-0.5 2.5]); ylim([0.5 2]);
box on;




