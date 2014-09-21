function res = scanErrorStatistic(poseRef,scans,map,dPose)
%SCANERRORSTATISTIC 
% 
% [poseError,tComputation] = SCANERRORSTATISTIC(poseRef,scans)
% 
% scans        - Array of size num scans x num pixels.
% poseRef      - Array of length 3.
% map          - lineMap object.
% dPose        - Perturbations. Array of size num perturbations x 3
% 
% poseError    - Pose estimate error (poseNorm) wrt poseRef, averaged over
%                perturbations and scans.
% tComputation - Average time to run registration.

localizer = lineMapLocalizer(map.objects);
refiner = laserPoseRefiner(struct('localizer',localizer,'laser',robotModel.laser,'skip',5,'numIterations',500));

poseError = 0;
tComputation = 0;
nScans = size(scans,1);
nPerturbations = size(dPose,2);
for i = 1:nScans
    for j = 1:nPerturbations
        poseInput = pose2D.addPoses(poseRef,dPose(:,j));
        [refinerStats,poseEst] = refiner.refine(scans(i,:),poseInput);
        poseError = poseError+pose2D.poseNorm(poseEst,poseRef);
        tComputation = tComputation+refinerStats.duration;
    end
end

res.tComputation = tComputation/(nScans*nPerturbations);
res.poseError = poseError/(nScans*nPerturbations);
end