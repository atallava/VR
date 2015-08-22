% specify environment
fNameMap = 'cluttered_box_map';
load(fNameMap);
fNameFieldPts = [fNameMap '_field_pts'];
load(fNameFieldPts);

%% specify sensor model
% laser gencal
load sim_sep6_1.mat
sensorModel = rsim;
sensorModel.setMap(map);
sensorModel.laser = laserClass(struct());
sensor = sensorModel.laser;
nBearings = sensorModel.laser.nBearings;
for i = 1:length(sensorModel.pxRegBundleArray)
    sensorModel.pxRegBundleArray(i).nBearings = nBearings;
end

% simulate sensor readings
N = length(fieldPts);
M = 100;
hArray = [];
count = 1;
clockLocal = tic();
for i = 1:N
    ranges = zeros(M,sensor.nBearings);
    pose = [fieldPts(i).x; fieldPts(i).y; 0];
    for j = 1:M
        ranges(j,:) = sensorModel.simulate(pose);
    end
    for j = 1:sensor.nBearings
        hArray(count,:) = ranges2Histogram(ranges(:,j),sensor);
        count = count+1;
    end
end
fprintf('Computation took %.2fs.\n',toc(clockLocal));

%% save to file
in.pre = '../data';
in.source = 'sim-laser-gencal';
in.tag = 'exp11-loss-field';
in.date = yymmddDate();
in.index = '';
fname = buildDataFileName(in);
save(fname,'map','fieldPts','hArray');