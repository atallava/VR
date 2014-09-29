load b100_padded_corridor
load motion_filter_object

localizer = lineMapLocalizer(map.objects);
sampleTrajectories = struct('poseArray',{},'tArray',{});
count = 1;
distThresh = 0.01^2;
while count <= 40
    [poseArray,tArray] = mfl.sampleTrajectory();
	
	%     d = localizer.closestSquaredDistanceToLines(poseArray);
	%     % Throw away trajectory if it is too close to corridor walls.
	%     if min(d) <= distThresh
	%         continue;
	%     end
	sampleTrajectories(count).poseArray = poseArray;
	sampleTrajectories(count).tArray = tArray;
	count = count+1;
end

save('sample_trajectories','sampleTrajectories');

