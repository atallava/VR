clearAll;
statsByPose = testScanMatch('baseline'); 
save('baseline_stats_new','statsByPose');
statsByPose = testScanMatch('sim'); 
save('sim_stats_new','statsByPose');
statsByPose = testScanMatch('sim_pooled'); 
save('sim_pooled_stats_new','statsByPose');
statsByPose = testScanMatch('sim_local_match'); 
save('sim_local_match_stats_new','statsByPose');