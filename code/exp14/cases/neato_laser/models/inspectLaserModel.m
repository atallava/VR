% assuming laserModel in workspace

%%
bId = 227;
bReg = laserModel.bearingRegressors{bId};

%%
hf = figure;
x = bReg.X(:,1); y = bReg.Y;
plot(x,y,'+');
xlim([-0.1 5]); ylim([-0.1 5]);
dcmObj = datacursormode(hf);
set(dcmObj,'UpdateFcn',@(obj,eventObj) tagPlotPointWithId(obj,eventObj,x,y));

%%
dataId = 12;
vizer = vizRangesOnMap(struct('map',laserModel.X(dataId).map,'laser',laserModel.laser));
vizer.viz(laserModel.Y(dataId).ranges,laserModel.X(dataId).sensorPose);
