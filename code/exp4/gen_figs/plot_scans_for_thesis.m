% redoing scans for thesis

%% load scans
load processed_data_sep6
load sim_sep6_2
load roomLineMap

%% pick pose, scan
scanId = 1;
poseId = 20;
pose = poses(:,poseId);
xl = [-0.3 4];
yl = [-0.2 2.1];
lineWidth = 2;
fontsize = 20;

%% real scans
ranges = rangesFromObsArray(obsArray, poseId, scanId);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlim(xl); ylim(yl);
for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontsize);

%% baseline sim scans
ranges = map.raycastNoisy(pose', rsim.laser.maxRange, rsim.laser.bearings);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlim(xl); ylim(yl);
for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontsize);

%% rsim scans
rsim.setMap(map);
ranges = rsim.simulate(pose);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlim(xl); ylim(yl);
for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontsize);

