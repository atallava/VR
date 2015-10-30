function poses_new = transformPoses(T,poses)

xy_old = poses(1:2,:);
xy_new = T*[xy_old; ones(1,size(xy_old,2))];
xy_new = xy_new(1:2,:);
alpha = atan2(T(2,1),T(1,1));
theta_new = mod(poses(3,:)+alpha,2*pi);
poses_new = [xy_new; theta_new];

end

