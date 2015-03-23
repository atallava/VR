load pcl_icp/icp_results_hk_160315.mat
load processed_data_hk_160315.mat
load nsh_4227_corner_plank_map
nPoses = size(poses,2);
localizer = lineMapLocalizer(map.objects);
newPoses = zeros(size(poses));
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',hkLaser));
plot_option = 1;

for i = 1:nPoses
    obsId = 1; % random
    ranges = rangesFromObsArray(obsArray,i,obsId);
    pose = poses(:,i);
    p2d = pose2D(pose);
    if icp_results(i).converged
        delT = icp_results(i).correctionT;
    else
        delT = eye(4);
    end
    delT(:,3) = []; delT(3,:) = [];
    newT = delT*p2d.Tb2w;
    x = newT(1,3); y = newT(2,3); th = atan2(newT(2,1),newT(1,1));
    newPose = [x; y; th];
    newPoses(:,i) = newPose;
    
    if plot_option
        vizer.viz(ranges,pose);
        title(sprintf('pose %d before icp',i));
        waitforbuttonpress
        vizer.viz(ranges,newPose);
        title(sprintf('pose %d after icp',i));
        waitforbuttonpress;
    end
end