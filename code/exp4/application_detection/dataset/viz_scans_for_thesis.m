% example scans for thesis

%% load
can = load('scans_real');
scansReal = can.scans;

can = load('scans_sim_sep6_1');
scansOur = can.scans;

can = load('scans_baseline');
scansBaseline = can.scans;

%% pick configuration, scan
nConfs = 30;
% scanId = randsample(nScans, 1);
confId = 12;
scanId = 5;
fprintf('scan id: %d\n', confId);

%% plot params
fontSize = 15;
pose = [0; 0; 0];

%% viz real
ranges = scansReal{confId}(scanId, :);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontSize);

%% viz our
ranges = scansOur{confId}(scanId,:);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontSize);

%% viz baseline
ranges = scansBaseline{confId}(scanId, :);
ri = rangeImage(struct('ranges',ranges));
hfig = ri.plotXvsY(pose); hold on;
xlabel('x (m)'); ylabel('y (m)');
set(gca, 'fontsize', fontSize);
