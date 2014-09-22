function sty = computeSimSensitivity(rsim,poseRef,map)
%COMPUTESIMSENSITIVITY 
% 
% sty = COMPUTESIMSENSITIVITY(rsim,poseRef,map)
% 
% rsim        - rangeSimulator object.
% poseRef     - Array of length 3.
% map         - lineMap object.
% 
% sty         - Scalar. Max difference in statistics over pose grid.

load('perturbations','perturbations');
load('poseGrid','poseGrid');
load('params','numScans');

scans = generateScansAtState(rsim,poseRef,map,numScans);
out = scanErrorStatistic(poseRef,scans,map,perturbations);
TRef = out.poseError;
sty = 0;

for i = 1:size(poseGrid,2)
    pose = pose2D.addPoses(poseRef,poseGrid(:,i));
    scans = generateScansAtState(rsim,pose,map,numScans);
    out = scanErrorStatistic(pose,scans,map,perturbations);
    if abs(out.poseError-TRef) > sty
        sty = abs(out.poseError-TRef);
    end
end

end

