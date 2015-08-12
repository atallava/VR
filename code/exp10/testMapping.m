clearAll;
load processed_data_milli_160215
mapSize = [-0.5 4; -0.5 5];

%%
om = occupancyMap(laserClass(struct()),mapSize);
obsId = 1:10;
t1 = tic();
% pass in ranges
for i = trainPoseIds
	for j = obsId
		ranges = rangesFromObsArray(obsArray,i,j);
		om.updateLogOdds(poses(:,i),ranges);
	end
end
om.calcBinaryGrid();
toc(t1)