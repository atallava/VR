clearAll;
load anecdote_data
load lineSetFixedLength
targetLengh = 0.6;

%% baseline on baseline
scanId = 8;
obsId = 1;
ranges = scans(scanId).baseline{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
%[lines,~] = showLines(ri,targetLengh);
[lines,~] = getLinesAnecdote(ri,targetLengh,@lineCandBaseline,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% baseline on real
ranges = scans(scanId).real{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[lines,~] = getLinesAnecdote(ri,targetLengh,@lineCandBaseline,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% sim on sim
scanId = 1;
obsId = 1;
ranges = scans(scanId).sim{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[lines,~] = getLinesAnecdote(ri,targetLengh,@lineCandSim,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);

%% sim on real
ranges = scans(scanId).real{obsId};
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[lines,~] = getLinesAnecdote(ri,targetLengh,@lineCandBaseline,1);
score = scoreLineFinding(lineSet{scans(scanId).poseId},lines);
