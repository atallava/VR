% init
% load data
fname = 'data_gencal/data_gencal_train';
data = load(fname);

% algo params
load('data/algo_param_eps_vector','eps0');
maxErr = 4.85;
epsScale = 0.0021;
eps = epsScale*eps0;

%% test algo
vizFlag = true;
steppingFlag = 0; % use with viz when stepping through data
localizer = lineMapLocalizer([]);
numIter = 200;
skip = 3;
nData = length(data.X);
errVec = zeros(1,nData);

refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,...
    'skip',skip,'numIter',numIter));

for i = 1%:nData
    map = data.X(i).map;
    localizer = lineMapLocalizer(map.objects);
    localizer.maxErr = maxErr;
    localizer.eps = eps;
    refiner.localizer = localizer;
    poseTrue = data.X(i).sensorPose;
    poseIn = data.X(i).perturbedPose;
    ranges = data.Y(i).ranges;
    poseOut = refiner.refine(ranges,poseIn);
    errVec(i) = pose2D.poseNorm(poseTrue,poseOut);
    
    % some viz
    ri = rangeImage(struct('ranges',ranges));
    pts = [ri.xArray; ri.yArray];
    ptsTrue = pose2D.transformPoints(pts,poseTrue);
    ptsIn = pose2D.transformPoints(pts,poseIn);
    ptsOut = pose2D.transformPoints(pts,poseOut);
    if vizFlag
        hf = map.plot();
        hold on;
        plot(ptsTrue(1,:),ptsTrue(2,:),'b.');
        plot(ptsIn(1,:),ptsIn(2,:),'r.');
        plot(ptsOut(1,:),ptsOut(2,:),'g.');
        annotation(hf,'textbox',[.6,0.6,.1,.1], ...
            'String', {'blue: map/ sensor pose','red: pose in','green: pose out'});
        title(sprintf('data id: %d',i));
        if steppingFlag
            waitforbuttonpress;
            close(hf);
        end
    end
end

obj = mean(errVec);