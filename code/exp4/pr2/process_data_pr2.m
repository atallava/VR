load raw_poses
load start_pose

poses = zeros(3,42);
dpose = start_pose-raw_poses(:,1);
poses = raw_poses+dpose; poses(3,:) = mod(poses(3,:),2*pi);