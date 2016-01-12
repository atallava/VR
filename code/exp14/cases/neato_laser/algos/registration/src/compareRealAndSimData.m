% datasets
fnameReal = '../src/data_gencal/data_gencal_train';
realFile = load(fnameReal);
datasetReal = realFile.dataset;
fnameSim = '../src/data_gencal/data_sim_train_des';
simFile = load(fnameSim);
datasetSim = simFile.dataset;

%% viz
steppingFlag = 0; % use with viz when stepping through data

nElements = length(datasetReal);
for id = 9%1:nElements
    X = datasetReal(id).X;
    YReal = datasetReal(id).Y;
    YSim = datasetSim(id).Y;
    map = X.map;
    sensorPose = X.sensorPose;
    rangesReal = YReal.ranges;
    rangesSim = YSim.ranges;
        
    riReal = rangeImage(struct('ranges',rangesReal));
    ptsReal = [riReal.xArray; riReal.yArray];
    ptsReal = pose2D.transformPoints(ptsReal,sensorPose);
    
    riSim = rangeImage(struct('ranges',rangesSim));
    ptsSim = [riSim.xArray; riSim.yArray];
    ptsSim = pose2D.transformPoints(ptsSim,sensorPose);
    
    %hf = map.plot();
    hf = figure; axis equal;
    hold on;
    plot(ptsReal(1,:),ptsReal(2,:),'g.');
    plot(ptsSim(1,:),ptsSim(2,:),'r.');
    annotation(hf,'textbox',[.6,0.6,.1,.1], ...
        'String', {'blue: map','green: real ranges','red: sim ranges'});
    title(sprintf('data id: %d',id));
    if steppingFlag
        waitforbuttonpress;
        close(hf);
    end
end
