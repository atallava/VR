% init
% load data
fname = 'data/data_sim_2_train_02';
% fname = 'data/data_gencal_2_train';
load(fname,'dataset');

% algo params
load('data/algo_param_eps_vector','eps0');
maxErr = 0.05;
epsScale = 0.001;
eps = epsScale*eps0;

%% test algo
load('data/algo_misc_params','numIter','skip');
load('laser_class_object','laser');
vizFlag = true;
steppingFlag = 0; % use with viz when stepping through data
localizer = lineMapLocalizer([]);
nElements = length(dataset);
errVec = zeros(1,nElements);

refiner = laserPoseRefiner(struct('localizer',localizer,'laser',laser,...
    'skip',skip,'numIterations',numIter));

for i = 73%1:nElements
    map = dataset(i).X.map;
    localizer = lineMapLocalizer(map.objects);
    localizer.maxErr = maxErr;
    localizer.eps = eps;
    refiner.localizer = localizer;
    poseTrue = dataset(i).X.sensorPose;
    poseIn = dataset(i).X.perturbedPose;
    ranges = dataset(i).Y.ranges;
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