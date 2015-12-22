initLocal;
load icp_results
load poses_after_scan_match
load raw_ranges
load nsh1_corridor
nPoses = size(poses,2);
localizer = lineMapLocalizer(nsh1_corridor.objects);
newPoses = zeros(size(poses));
bearings = deg2rad(-130:0.25:129.75); laser = laserClass(struct('bearings',bearings));
vizRanges = vizRangesOnMap(struct('map',map,'laser',laser));
plot_option = 1;

for i = 1:nPoses
    obsId = 100; % random
    ranges = squeeze(raw_ranges(i,obsId,:)); ranges = ranges';
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
        hf1 = vizRanges.viz(ranges,pose);
        title(sprintf('pose %d before icp',i));
        hf2 = vizRanges.viz(ranges,newPose);
        title(sprintf('pose %d after icp',i));
        % some fancy positioning for visibility
        figpos1 = get(hf1,'Position'); figpos2 = get(hf2,'Position');
        figwidth = figpos1(3); figshift = floor(figwidth*0.5+10);
        figpos1(1) = figpos1(1)-figshift; figpos2(1) = figpos2(1)+figshift;
        set(hf1,'Position',figpos1); set(hf2,'Position',figpos2);
                
        waitforbuttonpress;
        close all;
    end
end