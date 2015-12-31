% dataset
fname = 'data_gencal/data_sim_train';
data = load(fname);

%%
nX = length(X);
while true
    id = randsample(1:nX,1);
    map = data.X(id).map;
    sensorPose = data.X(id).sensorPose;
    perturbedPose = data.X(id).perturbedPose;
    ranges = data.Y(id).ranges;
    
    ri = rangeImage(struct('ranges',ranges));
    pts = [ri.xArray; ri.yArray];
    ptsSensor = pose2D.transformPoints(pts,sensorPose);
    ptsPerturbed = pose2D.transformPoints(pts,perturbedPose);
    
    hf = map.plot();
    hold on;
    plot(ptsSensor(1,:),ptsSensor(2,:),'g.');
    plot(ptsPerturbed(1,:),ptsPerturbed(2,:),'r.');
    annotation(hf,'textbox',[.6,0.6,.1,.1], ...
        'String', {'blue: map','green: sensor pose','red: perturbed pose'});
    title(sprintf('data id: %d',id));
    waitforbuttonpress
    close(hf);
end
