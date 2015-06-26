function mocapStruct = transformMocapStruct(mocapStruct,T)
%TRANSFORMMOCAPSTRUCT Transform all xyz coordinates.
% This is a clean but inefficient function.
% Currently rpy, quaternions are ignored by the transformation.
% 
% mocapStruct = TRANSFORMMOCAPSTRUCT(mocapStruct,T)
% 
% mocapStruct - Output of parseMocapData.
% T           - [4,4] array.
% 
% mocapStruct - ...


for i = 1:mocapStruct.frameCount
	% each frame
	% all rigid bodies in frame
	for j = 1:length(mocapStruct.frame(i).rigidBody)
		mocapStruct.frame(i).rigidBody{j}.xyz = transform3(mocapStruct.frame(i).rigidBody{j}.xyz,T);
	end
	% all markers in frame
	mocapStruct.frame(i).markerPosns = transform3(mocapStruct.frame(i).markerPosns,T);
	% each rigid body
	for j = 1:mocapStruct.rigidBodyCount
		mocapStruct.rigidBody{j}(i).markerPosns = transform3(mocapStruct.rigidBody{j}(i).markerPosns,T);
		mocapStruct.rigidBody{j}(i).pcPosns = transform3(mocapStruct.rigidBody{j}(i).pcPosns,T);
	end
end
end