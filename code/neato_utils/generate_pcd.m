% generate pcd of scans to pass to pcl icp

load processed_data_hk_160315
nPoses = size(poses,2);
fpath = '~/VR/code/pcl/scan_match/files/hokuyo_data/data_160315/';
for i = 1:nPoses
    obsId = 2; % random
    ranges = rangesFromObsArray(obsArray,i,obsId);
    pose = poses(:,i);
    ri = rangeImage(struct('ranges',ranges,'cleanup',1,'bearings',hkLaser.bearings));
    pts = [ri.xArray; ri.yArray];
    pts = pose2D.transformPoints(pts,pose);
    pts(3,:) = 0;
    
    fname = sprintf('%sscan_%d.pcd',fpath,i);
    savepcd(fname,pts);
end