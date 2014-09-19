clearAll;
load anecdote_data
load lineSetFixedLength
targetLine = 0.61;

%% baseline on baseline
scanId = 1;
obsId = 1;
ranges = scans(scanId).baseline{obsId};
ri = rangeImage(struct('ranges',ranges));
[lines,~] = showLines(ri,0.61);
%[lines,~] = getLinesAnecdote(ri,0.61,@lineCandBaseline,1,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% baseline on real
ranges = scans(scanId).real{obsId};
ri = rangeImage(struct('ranges',ranges));
[lines,~] = getLinesAnecdote(ri,0.61,@lineCandBaseline,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% sim on sim
scanId = 1;
obsId = 1;
ranges = scans(scanId).sim{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[lines,~] = getLinesAnecdote(ri,0.61,@lineCandSim,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% sim on real
ranges = scans(scanId).real{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[lines,~] = getLinesAnecdote(ri,0.61,@lineCandBaseline,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);
