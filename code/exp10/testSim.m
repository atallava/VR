%% on real data
load scRep_sep6

vsim = vaneSimulator(scRep);
pose = [0.1 0.1 deg2rad(0)];
ranges = vsim.simulate(pose);
ri = rangeImage(struct('ranges',ranges,'bearings',scRep.laser.bearings));
pts = [ri.xArray; ri.yArray];
pts = pose2D.transformPoints(pts,pose);
plot(pts(1,:),pts(2,:),'b.');
axis equal