% Check if targets found on real data are align with simulated target
% positions.
clc;

%%
close all;
confId = 1;
ranges = scans{confId}(1,:);
ri = rangeImage(struct('ranges',ranges,'cleanup',1));
[candidateLines,~] = getLinesAnecdote(ri,0.61,@lineCandSim,1);
hold on;
targetLines = targetLinesByConf{confId};
for i = 1:length(targetLines);
    plot([targetLines(i).p1(1) targetLines(i).p2(1)],[targetLines(i).p1(2) targetLines(i).p2(2)],'r');
end
hold off;
score = scoreLineFinding(targetLines,candidateLines);
title(sprintf('score: %d',score));