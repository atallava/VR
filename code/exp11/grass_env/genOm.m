load data_150903

%%
xMax = 5;
xMin = -5;
yMax = 5;
yMin = -5;
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

%%
og = om.logOdds2Prob(om.logOddsGrid);
bg = og > 0.5;

%%
hf = figure;
imagesc(flipud(1-bg));
colormap(gray);
xlabel('x (m)');
ylabel('y (m)');
axis equal;
