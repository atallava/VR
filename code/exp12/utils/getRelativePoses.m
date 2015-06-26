function relPoses = getRelativePoses(poses,refPose)
%GETRELATIVEPOSES Express poses relative to reference pose.
% Poses are all [x,y,theta].
% 
% relPoses = GETRELATIVEPOSES(poses,refPose)
% 
% poses    - [3,numPoses] array.
% refPose  - Length 3 vector.
% 
% relPoses - [3,numPoses] array.

nPoses = size(poses,2);
Tposes_world = pose2D.poseToTransform(poses);
if ~iscell(Tposes_world)
	Tposes_world = {Tposes_world};
end
TrefPose_world = pose2D.poseToTransform(refPose);
Tposes_refPose = cell(1,nPoses);
for i = 1:nPoses
	Tposes_refPose{i} = TrefPose_world\Tposes_world{i};
end
relPoses = pose2D.transformToPose(Tposes_refPose);
end