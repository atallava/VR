function scans = generateScansAtState(rsim,refPose,map,numScans)
%GENERATESCANSATSTATE 
% 
% scans = GENERATESCANSATSTATE(rsim,refPose,map,numScans)
% 
% rsim     - rangeSimulator object.
% refPose  - Array of length 3.
% map      - lineMap object.
% numScans - Scalar.
% 
% scans    - Array of size numScans x num pixels.

rsim.setMap(map);
scans = zeros(numScans,rsim.laser.nPixels);
for i = 1:numScans
	scans(i,:) = rsim.simulate(refPose);
end

end