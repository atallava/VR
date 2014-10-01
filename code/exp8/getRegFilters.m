% Real data
clearAll
load motion_vars
load('motion_filter_object','mfl')
load('b100_padded_corridor','map');
localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('localizer',localizer,'laser',robotModel.laser));

%% Real
load real_sensor_data

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('real');
    rflArray(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));
save('real_reg_filters','rflArray');

%% Sim
load sim_sensor_data

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('sim');
    rflArray(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));
save('sim_reg_filters','rflArray');

%% Baseline
load baseline_sensor_data

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('baseline');
    rflArray(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));
save('baseline_reg_filters','rflArray');
