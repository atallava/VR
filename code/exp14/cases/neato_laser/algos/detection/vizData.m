% dataset
fname = 'data_sim_train';
load(fname);
load laser_class_object

%%
xl = []; yl = []; setLims = false;
nData = length(X);
while true
    id = randsample(1:nData,1);
    % is a vizer necessary?
    vizer = vizRangesOnMap(struct('map',X(id).map,'laser',laser));
    vizer.viz(Y(id).ranges,X(id).sensorPose);
    if setLims
        xlim(xl); ylim(yl);
    end
    title(sprintf('id: %d',id));
    waitforbuttonpress
    vizer.togglePlot();
    clear vizer
end
