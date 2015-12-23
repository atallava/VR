% dataset
fname = 'data_gencal/data_gencal';
load(fname);

%%
nX = length(X);
while true
    id = randsample(1:nX,1);
    vizer = vizRangesOnMap(struct('map',X(id).map,'laser',laserClass(struct())));
    vizer.viz(Y(id).ranges,X(id).perturbedPose);
    waitforbuttonpress
    vizer.togglePlot();
    clear vizer
end
