clearAll;
load processed_data_sep13
load('map_sep13','map');
localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',200));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));

%% Make sure poses make sense

nPoses = size(poses,2);
obsId = 2;
for i = 1:nPoses
    ranges = rangesFromObsArray(obsArray,i,obsId);
    [~,poseEst] = refiner.refine(ranges,poses(:,i));
    vizer.viz(ranges,poseEst);
    %vizer.viz(ranges,poses(:,i));
    waitforbuttonpress;
end

%% Generate data
load('data_sep13_pattern_set','patternSet');

nPoses = size(poses,2);
poseEstCell = cell(1,nPoses);
t1 = tic;
for poseId = 1:nPoses
    fprintf('Pose %d...\n',poseId);
    poseEsts = [];
    for i = 1:10%size(patternSet,2)
        fprintf('Pattern %d...\n',i);
        posePerturbed = poses(:,poseId)+patternSet(:,i);
        for obsId = 1:length(obsArray{poseId,1})
            if mod(obsId-1,10) == 0
                fprintf('Scan %d...\n',obsId);
            end
            ranges = rangesFromObsArray(obsArray,poseId,obsId);
            [~,poseEst] = refiner.refine(ranges,posePerturbed);
            poseEsts(:,end+1) = poseEst;
        end
        fprintf('\n');
    end
    fprintf('\n\n');
    poseEstCell{poseId} = poseEsts;
end
fprintf('Finished. Computation took %0.2fs.\n',toc(t1));

