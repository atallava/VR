load box_map

%%
x.sensorPose = [0;0;0];
x.map = map;
y = laserModel.predict(x);
ranges = y.ranges;

%%
ri = rangeImage(struct('ranges',ranges));
ri.plotXvsY(x.sensorPose);
