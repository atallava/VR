%% Initializing
clearAll;
load calibration_orientation_multiplier_data
localizer = lineMapLocalizer(map.objects);
inputStruct.localizer = localizer;
refiner = laserPoseRefiner(inputStruct);
visualizer = vizRangesOnMap(struct('map',map));

posnRange = [0.05 0.5];
thRange = deg2rad([5 45]);
nSamples = 500;
data = struct('refinerIter',{},'errorIn',{},'errorOut',{});

for i = 1:nSamples
    if mod(i,10) == 0
        fprintf('sample %d\n',i);
    end
    rho = unifrnd(posnRange(1),posnRange(2));
    phi = rand*2*pi;
    poseIn = pose+rho*[cos(phi); sin(phi); 0];
    poseIn(3) = mod(poseIn(3)+unifrnd(thRange(1),thRange(2)),2*pi);
    refiner.numIterations = randperm(25,1)*10;
    data(i).refinerIter = refiner.numIterations;
    data(i).errorIn = poseDiffNormError(pose,poseIn);
    [poseOut,success] = refiner.refine(ranges,poseIn);
    data(i).errorOut = poseDiffNormError(pose,poseOut);
end
fprintf('Finished.\n');