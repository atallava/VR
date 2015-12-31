% probe laser model
cond = logical(exist('laserModel','var'));
assert(cond,('laserModel must exist in workspace.'));

%% 
bId = 26;
bReg = laserModel.bearingRegressors{bId};

%%
hf = figure;
x = bReg.X(:,1); y = bReg.Y;
plot(x,y,'+');
xlim([-0.1 5]); ylim([-0.1 5]);
dcmObj = datacursormode(hf);
set(dcmObj,'UpdateFcn',@(obj,eventObj) tagPlotPointWithId(obj,eventObj,x,y));

%%
dataId = 9;
vizer = vizRangesOnMap(struct('map',laserModel.X(dataId).map,'laser',laserModel.laser));
vizer.viz(laserModel.Y(dataId).ranges,laserModel.X(dataId).sensorPose);
