% initialize
nPoses = 10;
nObs = 50;
poseHistory = zeros(3,nPoses);
rangeHistory = [];
dataCount = 1;
obsCount = 1;

%% record data
% poseOut comes from hkLocalization
fprintf('Data count: %d\n',dataCount);
poseHistory(:,dataCount) = poseOut; 
for i = 1:nObs
	pause(0.2);
	rangeHistory(obsCount,:) = hk.ranges;
	obsCount = obsCount+1;
end
dataCount = dataCount+1;
fprintf('Continue.\n');

%% save to file
fname = 'data_hk_test_160315';
save(fname,'nObs','poseHistory','rangeHistory');