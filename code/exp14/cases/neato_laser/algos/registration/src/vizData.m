% dataset
fname = 'data_gencal/data_sim_train_obs';
load(fname,'dataset');

%%
nElements = length(dataset);
while true
    id = randsample(1:nElements,1);
    X = dataset(id).X;
    Y = dataset(id).Y;
    map = X.map;
    sensorPose = X.sensorPose;
    perturbedPose = X.perturbedPose;
    ranges = Y.ranges;
    
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
    title(sprintf('element id: %d',id));
    waitforbuttonpress
    close(hf);
end
