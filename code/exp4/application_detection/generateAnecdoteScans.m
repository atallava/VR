% Generate data to be used in detection anecdote.
clearAll
load processed_data_june6
load lineSetFixedLength
load('../mats/full_predictor_sep6_2.mat','rsim');
load map1.mat

%%
nPoses = length(obsArrayByPose);
nTrials = 10;
numLines = 2;
targetLen = 0.61;

robotPose = [0;0;0];
poseId = [7 2 10 8 2 4 5 6];
nScans = 5;
for i = 1:length(poseId)
    scans(i).poseId = poseId(i);
    lObjArray = lines2LineObjects(lineSet{poseId(i)});
    tempMap = lineMap([room.objects lObjArray]);
    rsim.setMap(tempMap);
    for j = 1:nScans
        scans(i).real{j} = obsArrayByPose{poseId(i)}(randperm(size(obsArrayByPose{poseId(i)},1),1),:);
        scans(i).baseline{j} = tempMap.raycastNoisy(robotPose,robotModel.laser.maxRange,robotModel.laser.bearings);
        scans(i).sim{j} = rsim.simulate(robotPose);
    end
end