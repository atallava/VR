function pts2 = transform3(pts1,T)
% pts are [3,numPoints] or [4,numPoints]
% T is [4,4]

homogenous = 1;
if size(pts1,1) == 3
	homogenous = 0;
	pts1(4,:) = ones(1,size(pts1,2));
end
pts2 = T*pts1;
if ~homogenous
	pts2(4,:) = [];
end
end