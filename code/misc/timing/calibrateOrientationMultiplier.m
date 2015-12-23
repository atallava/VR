%% Initializing
clearAll;
load calibration_orientation_multiplier_data
localizer = lineMapLocalizer(map.objects);
inputStruct.localizer = localizer; inputStruct.numIterations = 10;
refiner = laserPoseRefiner(inputStruct);
visualizer = vizRangesOnMap(struct('map',map));

posnNormArray = [0.01 0.05 0.1 0.5];
posnIterArray = zeros(size(posnNormArray));
nPosnTrials = 3;
thArray = deg2rad([5 10 20 30]);
thIterArray = zeros(size(thArray));
errThresh = 0.0035;

%% Position perturbations
fprintf('Evaluating position perturbations.\n');
for i = 1%:length(posnNormArray)
    fprintf('%d...\n',i);
    temp = [];
    for j = 1:nPosnTrials
        phi = rand*2*pi;
        poseDummy = pose+posnNormArray(i)*[cos(phi); sin(phi); 0];
        count = 0;
        err = Inf; 
        while err > errThresh
            [poseDummy,success] = refiner.refine(ranges,poseDummy);
            err = success.err;
            count = count+1;
        end
        temp(end+1) = inputStruct.numIterations*count;
    end
    posnIterArray(i) = mean(temp);
end

%% Orientation perturbations
fprintf('Evaluating orientation perturbations.\n');
for i = 1:length(thArray);
    fprintf('%d...\n',i);
    poseDummy = pose+[0;0;thArray(i)];
    poseDummy(3) = mod(poseDummy(3),2*pi);
    count = 0;
    err = Inf;
    while err > errThresh
        [poseDummy,success] = refiner.refine(ranges,poseDummy);
        err = success.err;
        count = count+1;
    end
    thIterArray(i) = inputStruct.numIterations*count;    
end