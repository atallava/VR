load linear_motion_data
nPoses = size(poseStart,2);
[encResidual,commandResidual] = deal(zeros(size(poseStart)));
for i = 1:nPoses
    posePredicted = poseStart(:,i);
    posePredicted(1) = posePredicted(1)+0.2;
    %posePredicted(3) = posePredicted(3)+pi/2;
    commandResidual(:,i) = poseFinal(:,i)-posePredicted;
    commandResidual(3,i) = thDiff(posePredicted(3),poseFinal(3,i));
    encResidual(:,i) = poseFinal(:,i)-poseEncFinal(:,i);
    encResidual(3,i) = thDiff(poseEncFinal(3,i),poseFinal(3,i));
end
