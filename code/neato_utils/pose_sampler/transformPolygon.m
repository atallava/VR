function newPolygon = transformPolygon(arg1,polygon)
% arg1 is T or pose
% T is [3,3] transform array
% pose is [x,y,theta]
% polygon is struct with fields ('xv','yv')

if numel(arg1) == 3
    pose = arg1;
    T = pose2D.poseToTransform(pose);
else 
    T = arg1;
end

pts = polygonToHomogenousPts(polygon);
pts = T*pts;
newPolygon.xv = pts(1,:);
newPolygon.yv = pts(2,:);
end

