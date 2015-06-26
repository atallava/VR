function [pts,timeStamps] = getRigidBodyXYZ(mocapStruct,id)
% id is rigidBody id
pts = zeros(3,mocapStruct.frameCount);
timeStamps = zeros(1,mocapStruct.frameCount);
count1 = 0;
count2 = 0;
while count1 < mocapStruct.frameCount
	count1 = count1+1;
	frame = mocapStruct.frame(count1);
	if ~frame.rigidBodyCount
		continue;
	end
	for i = 1:length(frame.rigidBody)
		rigidBody = frame.rigidBody{i};
		if rigidBody.id == id
			count2 = count2+1;
			pts(:,count2) = rigidBody.xyz;
			timeStamps(count2) = frame.timeStamp;
			break; % from the inner for loop
		end
	end
end
if count2+1 < mocapStruct.frameCount
	pts(:,count2+1:end) = [];
	timeStamps(count2+1:end) = [];
end
end