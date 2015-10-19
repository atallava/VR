function poseLogOut = smoothPoseLog(poseLogIn)

meanPeriod = 0.008; % s
maxVel = 0.3; % m/s
bound = meanPeriod*maxVel;
ids = [];

% trusting reading 1
for i = 2:length(poseLogIn)
	if abs(poseLogIn(1,i)-poseLogIn(1,i-1)) > bound
		ids = [ids i];
	end
end

poseLogOut = poseLogIn;
for i = 1:floor(length(ids)*0.5)
	posn1 = ids(2*i-1);
	posn2 = ids(2*i);
	replacement = 0.5*(poseLogIn(:,posn1-1)+poseLogIn(:,posn2));
	poseLogOut(:,posn1:posn2-1) = repmat(replacement,1,posn2-posn1);
end
end