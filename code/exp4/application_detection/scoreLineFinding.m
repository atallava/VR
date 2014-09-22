function score = scoreLineFinding(targetLines,candidateLines)
%SCORELINEFINDING
%
% score = SCORELINEFINDING(targetLines,candidateLines)
%
% targetLines    - Struct array with fields ('p1','p2').
% candidateLines - Struct array with fields ('p1','p2').
%
% score          - Number of targets in candidates.

score = 0;
for i = 1:length(targetLines)
    for j = 1:length(candidateLines)
         if checkLinePair(targetLines(i),candidateLines(j))
            score = score+1;
            candidateLines(j) = [];
            break;
        end
    end
end
end

function res = checkLinePair(target,candidate)
%CHECKLINEPAIR Check equality of a pair of lines.
% 
% res = CHECKLINEPAIR(target,candidate)
%
% target    - Struct with fields ('p1','p2').
% candidate - Struct with fields ('p1','p2').
%
% res       - true if candidate is 'close to' target, false if else.

threshold = 0.05;
mid_target = (target.p1+target.p2)*0.5;
mid_candidate = (candidate.p1+candidate.p2)*0.5;
target_segment = target.p2-target.p1; candidate_segment = candidate.p2-candidate.p1;
if checkSegment(target_segment,candidate_segment) && norm(mid_target-mid_candidate) < threshold
    res = true;
else
    res = false;
end

end

function res = checkSegment(targetSegment,candidateSegment)

toleranceTh = deg2rad(5);
toleranceLength = 0.06;

targetLen = norm(targetSegment);
candidateLen = norm(candidateSegment);
targetTh = atan(targetSegment(2)/targetSegment(1));
candidateTh = atan(candidateSegment(2)/candidateSegment(1));

lenCheck = toleranceCheck(candidateLen,targetLen,toleranceLength);
thCheck = thetaCheck(candidateTh,targetTh,toleranceTh);
if  lenCheck && thCheck
    res = 1;
else
    res = 0;
end
end