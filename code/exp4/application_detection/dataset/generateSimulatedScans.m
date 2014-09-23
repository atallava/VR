function scans = generateSimulatedScans(rsim,confList,pose,numScans)
%GENERATESIMULATEDSCANS 
% 
% scans = GENERATESIMULATEDSCANS(rsim,confList,pose,numScans)
% 
% rsim     - abstractSimulator object.
% confList - Array of sampleConfiguration objects.
% pose     - Array of size 3. Pose of sensor.
% numScans - Scalar.
% 
% scans    - Cell of size of confList. 

% Should be a functionality of a sampleConfiguration.
nConfs = length(confList);
scans = cell(1,nConfs);
for i = 1:nConfs
    confList(i).createMap();
    rsim.setMap(confList(i).map);
    for j = 1:numScans
        scans{i}(j,:) = rsim.simulate(pose);
    end
end

end