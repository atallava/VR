function err = poseDiffNormError(poseA,poseB)
%POSEDIFFNORMERROR Pose error based on difference norm.
% Uses an orienation multiplier to convert radian to length units.
% 
% err = POSEDIFFNORMERROR(poseA,poseB)
% 
% poseA - Length 3 array.
% poseB - Length 3 array.
% 
% err   - Scalar.

orientationMultiplier = 0.5/0.45;
err = poseA-poseB;
err(3) = atan2(cos(poseA(3)-poseB(3)),sin(poseA(3)-poseB(3)));
err(3) = orientationMultiplier*err(3);
err = norm(err);
end

