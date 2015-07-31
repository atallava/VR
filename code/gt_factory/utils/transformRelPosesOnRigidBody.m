function posesB = transformRelPosesOnRigidBody(posesA,Ta_b)
%TRANSFORMRELPOSESONRIGIDBODY Transform sequence of relative poses of a rigid body to
% another frame attached to the same rigid body. Relative means absence of
% a world frame.
% 
% posesB = TRANSFORMRELPOSESONRIGIDBODY(posesA,T)
% 
% posesA - [3,numPoses] array. Corresponds to Ta1_a0, Ta2_a0, ...
% Ta_b   - [3,3] array. 
% 
% posesB - [3,numPoses] array. Corresponds to Tb1_b0, Tb2_b0, ...

posesB = zeros(size(posesA));
numPoses = size(posesA,2);

for i = 1:numPoses
	Tai_a0 = pose2D.poseToTransform(posesA(:,i));
	Tbi_b0 = Ta_b*Tai_a0/Ta_b;
	posesB(:,i) = pose2D.transformToPose(Tbi_b0);
end

end