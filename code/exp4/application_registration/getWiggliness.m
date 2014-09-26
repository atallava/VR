function res = getWiggliness(scans,pose0,map,perturbations)

localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',500));

% Get one local minima.
[~,poseRef] = refiner.refine(scans(1,:),pose0);
res.poseRef = poseRef;

nScans = size(scans,1);
nPert = size(perturbations,2);
count = 1;
for i = 1:nScans
    ranges = scans(i,:);
    for j = 1:nPert
        poseIn = pose2D.addPoses(poseRef,perturbations(:,j));
        [res(count).stats,res(count).pEst] = refiner.refine(ranges,poseIn);
        count = count+1;
    end
end

end