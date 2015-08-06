function hf = drawRigidBody2(rigidBodyDetail)
% rigidBodyDetail comes from mocapStruct
% draws only x and y axes
hf = figure; axis equal;
scatter(rigidBodyDetail.relMarkerPosn(1,:),rigidBodyDetail.relMarkerPosn(2,:),'ro');
title(sprintf('Name: %s, id: %d',rigidBodyDetail.name,rigidBodyDetail.id));
end