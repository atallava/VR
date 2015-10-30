% generate pcd of scans to pass to pcl icp
load raw_ranges
load poses_after_scan_match
nPoses = size(poses,2);
fpath = '~/VR/code/pcl/scan_match/pr2_data/';
load ../nsh1_corridor.mat
localizer = lineMapLocalizer(nsh1_corridor.objects);
bearings = deg2rad(-130:0.25:129.75);
for i = 1:nPoses
    obsId = 100; % random
    ranges = squeeze(raw_ranges(i,obsId,:)); ranges = ranges';
    pose = poses(:,i);
    x = pose(1)+ranges.*cos(pose(3)+bearings);
    y = pose(2)+ranges.*sin(pose(3)+bearings);
    pcd = [x; y; zeros(1,length(x))];
    %outIds = localizer.throwOutliers(pcd);
    %pcd(:,outIds) = [];
    
    fname = sprintf('%sscan_%d.pcd',fpath,i);
    savepcd(fname,pcd);
end