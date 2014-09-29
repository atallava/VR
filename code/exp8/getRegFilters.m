% Real data
clearAll
load motion_vars
load('b100_padded_corridor','map');

%% Real
load data_sep28_micro

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('real');
    [scanArray,tArray] = laserHist2scanArray(sensorData(i).lzr,sensorData(i).tfl);
    rflArray(i).filter(ssp.startPose,S0,scanArray,tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));

%% Sim
load sim_sensor_data

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('sim');
    rflArray(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));

%% Baseline
load baseline_sensor_data

clear rflArray
t1 = tic();
for i = 1:length(sensorData)
    rflArray(i) = registrationFilter('baseline');
    rflArray(i).filter(ssp.startPose,S0,sensorData(i).scanArray,sensorData(i).tArray,map);
end
fprintf('Computation took %.2fs\n',toc(t1));

