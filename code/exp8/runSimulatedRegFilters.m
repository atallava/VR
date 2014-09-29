load motion_vars
load nsh3_corridor

%% Sim
load sim_traj_samples_data
t1 = tic();
for i = 1:length(sensorData)
    filt(i) = registrationFilter('sim');
    filt(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray);
end
fprintf('%.2fs\n',toc(t1));
save('sim_reg_filters','filt');

%% Baseline
load baseline_traj_samples_data
clear filt
t1 = tic();
for i = 1:length(sensorData)
    filt(i) = registrationFilter('baseline');
    filt(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray);
end
fprintf('%.2fs\n',toc(t1));
save('baseline_reg_filters','filt');