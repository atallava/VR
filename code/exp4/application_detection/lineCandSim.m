function res = lineCandSim(ri,middle,maxLen,showMsgs)
% Copy of algo for baseline development.

if nargin < 4
    showMsgs = false;
end

res = [];
% minimum points that should be participating
nMin = 8;
% line candidate length should be within tolerance of desired
% length
lengthTolerance = 0.05;
% threshold for average point error
errorThresh = 0.02;
% threshold to consider a point part of a line
memberThresh = 0.03;
% if number of outliers is >= this fraction of total points, fail
outlierFraction = 0.2;

error = 0;

left = middle;
right = middle;

% Admit candidates. Increase recall.

% Grow line till within length threshold.
while true
    lineLength = norm([ri.xArray(left)-ri.xArray(right) ...
        ri.yArray(left)-ri.yArray(right)]);
    if lineLength > maxLen
        break;
    end
    left = ri.indexAdd(left,-1); right = ri.indexAdd(right,1);
end
if ~toleranceCheck(lineLength,maxLen,lengthTolerance)
    left = ri.indexAdd(left,1);
    right = ri.indexAdd(right,-1);
    lineLength = norm([ri.xArray(left)-ri.xArray(right) ...
        ri.yArray(left)-ri.yArray(right)]);
end
if ~toleranceCheck(lineLength,maxLen,lengthTolerance)
    if showMsgs
         fprintf('length not close enough to % f\n',maxLen);
    end
    return;
end
if right > left
    num = (right-left)+1;
else
    num = (ri.nPix-left)+1+right;
end

p1 = [ri.xArray(left); ri.yArray(left)];
p2 = [ri.xArray(right); ri.yArray(right)];
line = ParametrizePts2ABC(p1,p2);

if showMsgs
    fprintf('middle: % d, left: % d, right: % d\n',middle,left,right);
    fprintf('length: % f, number of points: % f\n',lineLength,num);
end

% Filter false negatives. Increase precision.

% Remove outliers. Check if many points were outliers. 
id = left;
outliers = [];
while id ~= right
    id = ri.indexAdd(id,1);
    err = distToLine2D([ri.xArray(id) ri.yArray(id)],line);
    if err > memberThresh
        outliers(end+1) = id;
    end
end
numOutliers = length(outliers);
if showMsgs
    fprintf('% d outliers\n',numOutliers);
end
if (numOutliers/num) >= outlierFraction
    if showMsgs
        fprintf('outliers are % f fraction of total points, ignoring model',(numOutliers/num));
    end
    return;
end

% Check number of participating points.
% num = num-numOutliers;
if num < nMin
    if showMsgs
        fprintf('not enough points after removing outliers\n');
    end
    return;
end

% Find average point error. Check for large errors.
id = left;
while id ~= right
    id = ri.indexAdd(id,1);
%     if ismember(id,outliers)
%         continue;
%     end
    error = error+distToLine2D([ri.xArray(id) ri.yArray(id)],line);
end
error = error/num;
if showMsgs
    fprintf('average point error: % f\n',error);
end
if error > errorThresh
    % average error too large
    if showMsgs
        fprintf('error larger than threshold % f\n',errorThresh);
    end
    return;
end

th = atanLine2D(line(1),line(2));
if showMsgs
    fprintf('theta % f\n',rad2deg(th));
end

res = struct('error',error,'th',th,'num',num,'left',left,'right',right);
end