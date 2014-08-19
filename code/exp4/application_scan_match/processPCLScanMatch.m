load pcl_icp_scan_match
load pcd_file_data
load application_test_data
load ../mats/roomLineMap

localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer));
choices = {'real','baseline','sim','sim_pooled','sim_local_match'};
count = 1;
for ch = choices
  choice = ch{1};
  fprintf('%s...\n',choice);
  for i = 1:nPoses
    for j = 1:nPatterns
      vec = [];
      poseIn = data(i).pose+patternSet(:,j);
      for k = 1:nObs
	delT = icp_results(count).correctionT;
	if all(delT == 0)
	  delT = eye(4);
	end
	delT(:,3) = []; delT(3,:) = [];
	Tout = delT*pose2D.poseToTransform(poseIn);
	poseOut = pose2D.transformToPose(Tout);
    vec(end+1) = pose2D.poseNorm(poseOut,data(i).pose);
	count = count+1;
      end
      stats(j).poseError.mu = mean(vec); stats(j).poseError.s = std(vec);
    end
    statsByPose(i).errorStats = stats;
  end
  fname = sprintf('%s_stats_pcl.mat',choice);
  save(fname,'statsByPose');
end
  
  
  		  
		  
		  
		  