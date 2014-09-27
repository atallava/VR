function scans = generateScansAtState(rsim,poseRef,map,numScans)
%GENERATESCANSATSTATE 
% 
% scans = GENERATESCANSATSTATE(rsim,poseRef,map,numScans)
% 
% rsim     - rangeSimulator object.
% poseRef  - Array of length 3. Robot pose.
% map      - lineMap object.
% numScans - Scalar.
% 
% scans    - Array of size numScans x num pixels.

rsim.setMap(map);
scans = zeros(numScans,rsim.laser.nPixels);
laserPose = rsim.laser.refPoseToLaserPose(poseRef);
for i = 1:numScans
	scans(i,:) = rsim.simulate(laserPose);
end

end