function score = scoreLineFinding(targetLines,candidateLines)
% targetLines, candidateLines are ('p1','p2') struct arrays
% score is the fraction of targetLines in candidateLines
score = 0;
for i = 1:length(targetLines)
    targetSegment = targetLines(i).p2-targetLines(i).p1;
    for j = 1:length(candidateLines)
        candidateSegment = candidateLines(j).p2-candidateLines(j).p1;
        %if checkSegment(targetSegment,candidateSegment)
         if checkLinePair(targetLines(i),candidateLines(j))
            score = score+1;
            candidateLines(j) = [];
            break;
        end
    end
end
score = score/length(targetLines);

end

function res = checkLinePair(target,candidate)
threshold = 0.01;
if (norm(candidate.p2-target.p2) < threshold) && (norm(candidate.p1-target.p1) < threshold) || ...
        (norm(candidate.p2-target.p1) < threshold) && (norm(candidate.p1-target.p2) < threshold)
    res = true;
else
    res = false;
end
end

function res = checkSegment(targetSegment,candidateSegment)
% TODO: horrible mess of angle check
toleranceTh = deg2rad(10);

targetLen = norm(targetSegment);
candidateLen = norm(candidateSegment);
targetTh = wrapTo2Pi(atan(targetSegment(2)/targetSegment(1)));
candidateTh = wrapTo2Pi(atan(candidateSegment(2)/candidateSegment(1)));
lenCheck = toleranceCheck(candidateLen,targetLen,targetLen/2);
thCheck = thetaCheck(candidateTh,targetTh,toleranceTh);
if  lenCheck && thCheck
    res = 1;
else
    res = 0;
end
end


function res = thetaCheck(th1,th2,tolerance)
% given th1 and th2 are within [0,2*pi]

res = toleranceCheck(th1,th2,tolerance);
thmax = max(th1,th2);
thmin = min(th1,th2);
res = res | (thmin < wrapTo2Pi(thmax+tolerance));
end