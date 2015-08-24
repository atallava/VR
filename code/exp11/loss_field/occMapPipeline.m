% run occupancy mapping
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-mapping';
in.date = '150821'; 
in.index = '3';
fileName = buildDataFileName(in);
load(fileName);

fNameMap = 'cluttered_box_map';
fNameFieldPts = [fNameMap '_field_pts'];
load(fNameFieldPts);

%% Create occ map
padding = 1;
xMax = max(support.xv)+padding;
xMin = min(support.xv)-padding;
yMax = max(support.yv)+padding;
yMin = min(support.yv)-padding;
mapSize = [xMin xMax; yMin yMax];
% this occupancy map only designed to work with laser
om = occupancyMap(sensor,mapSize);

%% roadwork
clockLocal = tic();
for i = trainIds(25:29)
    nObs = length(obsArray{i,1});
	for j = 1:nObs
		ranges = rangesFromObsArray(obsArray,i,j);
		om.updateLogOdds(poses(:,i),ranges);
	end
end
om.calcBinaryGrid();
fprintf('Occupancy map in %.2fs.\n',toc(clockLocal));

%% Estimate histograms
N = length(fieldPts);
hArray = [];
for i = 1:N
    pose = [fieldPts(i).x; fieldPts(i).y; 0];
    [h,xc] = sensorModel.estimateHistograms(pose);
    hArray((i-1)*sensor.nBearings+1:i*sensor.nBearings,:) = h;
end

%% Save to file
% run occupancy mapping
in.pre = '../data/';
in.tag = 'exp11-loss-field-occmap';
fileName = buildDataFileName(in);
save(fileName,'om','hArray','xc','-v7.3');