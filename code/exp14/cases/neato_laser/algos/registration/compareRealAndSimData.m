% datasets
fnameReal = 'data_gencal/data_gencal_train';
dataReal = load(fnameReal);
fnameSim = 'data_gencal/data_sim_train';
dataSim = load(fnameSim);

%% calc loss
[loss,lossVec] = calcLossBaseline(dataReal,dataSim);

%% viz
steppingFlag = 1; % use with viz when stepping through data

nData = length(dataReal.X);
for id = 1:nData
    map = dataReal.X(id).map;
    sensorPose = dataReal.X(id).sensorPose;
    rangesReal = dataReal.Y(id).ranges;
    rangesSim = dataSim.Y(id).ranges;
        
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
