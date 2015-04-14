clearAll;
pose = [1; 1; 0];
lzr = laserClass(struct());
ranges = [0.5*ones(1,180) 0.25*ones(1,180)];

%%
om = occupancyMap();
om.lzr = lzr;
om.gridUp([0 2; 0 2]);
om.initLogOddsGrid();

%%
om.updateLogOdds(pose,ranges);