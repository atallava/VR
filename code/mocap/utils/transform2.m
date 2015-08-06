function pts2 = transform2(pts1,T)
% pts are [2,numPoints] or [3,numPoints]
% T is [3,3]

homogenous = 1;
if size(pts1,1) == 2
	homogenous = 0;
	pts1(3,:) = ones(1,size(pts1,2));
end
pts2 = T*pts1;
if ~homogenous
	pts2(3,:) = [];
end
end