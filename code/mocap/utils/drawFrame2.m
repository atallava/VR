function hf = drawFrame2(frame)
% frame comes from mocapStruct
% draws only x and y axes

hf = figure; axis equal; hold on;
% draw markers
x = frame.markerPosns(1,:);
y = frame.markerPosns(2,:);
scatter(x,y,'ro','linewidth',2);
dx = 0.01; dy = 0.01;
labels = frame.markerNames;
text(x+dx,y+dy,labels);

% draw rigid bodies
x = []; y = []; labels = [];
for i = 1:frame.rigidBodyCount
	x = [x frame.rigidBody{i}.xyz(1)];
	y = [y frame.rigidBody{i}.xyz(2)];
	labels = [labels frame.rigidBody{i}.id];
end
scatter(x,y,'bx','linewidth',2);
labels = cellstr(num2str(labels));
text(x+dx,y+dy,labels);

title(sprintf('Timestamp: %.2fs.',frame.timeStamp));
end