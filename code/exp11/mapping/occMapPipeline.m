% run occupancy mapping
in.pre = 'data';
in.source = 'sim-laser-gencal'; 
in.tag = 'exp11-mapping';
in.date = '150819'; 
in.index = '';
fname = buildDataFileName(in);

%% Create occ map
xMax = max(support.xv);
xMin = min(support.xv);
yMax = max(support.yv);
yMin = min(support.yv);
mapSize = [xMin xMax; yMin yMax];
% this occupancy map only designed to work with laser
om = occupancyMap(sensor,mapSize);

clockLocal = tic();
for i = trainIds
    nObs = length(obsArray{i,1});
	for j = 1:nObs
		ranges = rangesFromObsArray(obsArray,i,j);
		om.updateLogOdds(poses(:,i),ranges);
	end
end
om.calcBinaryGrid();
fprintf('Occupancy map in %.2fs.\n',toc(clockLocal));

%% Simulate
rangesHold = zeros(length(posesHold));
for i = 1:length(posesHold)
    pId = posesHold(i);
    rangesHold(i,:) = om.raycast(poses(:,pId),sensor.maxRange,sensor.bearings);
end
compTime = toc(clockLocal);
fprintf('Computation took %.2fs.\n',compTime);

%% Calculate error

%% Save to file