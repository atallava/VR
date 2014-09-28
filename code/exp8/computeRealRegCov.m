clearAll
load reg_cov_map
load processed_data_sep27
numScans = 50;
nPoses = size(poses,2);

%%
scans = cell(1,nPoses);
for i = 1:nPoses
    scans{i} = rangesFromObsArray(obsArray,i,1:numScans);
end
[bias,S] = computeRegCov(poses,scans,map);
save('real_reg_cov','bias','S');
