function [nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandidateAlgo)

nConfs = length(scans);
[nDetected,nCorrect,nTargets] = deal(zeros(1,nConfs));

for i = 1:nConfs
    nScans = size(scans{i},1);
    targetLines = targetLinesByConf{i};
    nTargets(i) = length(targetLines);
    vec1 = []; vec2 = [];
    for j = 1%:nScans
        % Cleanup or not is also a step in algorithm design.
        ri = rangeImage(struct('ranges',scans{i}(j,:),'cleanup',0));
        [detectedLines,~] = getLinesAnecdote(ri,targetLength,lineCandidateAlgo);
        vec1 = [vec1 length(detectedLines)];
        temp = scoreLineFinding(targetLines,detectedLines);
        vec2 = [vec2 temp];
    end
    nDetected(i) = mean(vec1);
    nCorrect(i) = mean(vec2);
end

p = sum(nCorrect)/sum(nDetected);
r = sum(nCorrect)/sum(nTargets);
end