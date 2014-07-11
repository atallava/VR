load poses_after_icp_mar27
load map
nPoses = size(poses,2);
laser = laserClass(struct());
muArray = zeros(nPoses,laser.nPixels);
for i = 1:nPoses
    [muArray(i,:),~] = roomLineMap.raycast(poses(:,i),laser.maxRange,laser.bearings);
end
save('simulated_means_mar27.mat','muArray');