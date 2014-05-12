function score = scoreLineFinding(targetLines_p1, targetLines_p2, candidateLines_p1, candidateLines_p2)

score = 0;
for i = 1:size(targetLines_p1,2)
    targetSegment = targetLines_p2(:,i)-targetLines_p1(:,i);
    for j = 1:size(candidateLines_p1,2)
        candidateSegment = candidateLines_p2(:,j)-candidateLines_p1(:,j);
        if check(targetSegment,candidateSegment)
            score = score+1;
            candidateLines_p1(:,j) = []; candidateLines_p2(:,j) = [];
            break;
        end
    end
end
score = score/size(targetLines_p1,2);

end

function res = check(targetSegment,candidateSegment)
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