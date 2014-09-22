function res = lineCandBaseline(ri,middle,maxLen,showMsgs)
% Copy of algo for baseline development.

if nargin < 4
    showMsgs = false;
end

res = [];
% minimum points that should be participating
nmin = 10;
% line candidate length should be within tolerance of desired
% length
length_tolerance = 0.05;
% threshold for average point error
error_thresh = 0.015;
% threshold to consider a point part of a line
member_thresh = 0.01;
% if number of outliers is >= this fraction of total points, fail
outlier_fraction = 0.25;

error = 0;

left = middle;
right = middle;

% Admit candidates.

% Step 1: grow line till maxLength is exceeded.
while true
    line_length = norm([ri.xArray(left)-ri.xArray(right) ...
        ri.yArray(left)-ri.yArray(right)]);
    if line_length > maxLen
        break;
    end
    left = ri.indexAdd(left,-1); right = ri.indexAdd(right,1);
end
if (line_length-maxLen) > length_tolerance
    left = rangeImage_obj.indexAdd(left,1);
    right = rangeImage_obj.indexAdd(right,-1);
    line_length = norm([rangeImage_obj.xArray(left)-rangeImage_obj.xArray(right) ...
        rangeImage_obj.yArray(left)-rangeImage_obj.yArray(right)]);
end
if right > left
    num = (right-left)+1;
else
    num = (ri.nPix-left)+1+right;
end
if showMsgs
    fprintf('middle: % d, left: % d, right: % d\n',middle,left,right);
    fprintf('length: % f, number of points: % f\n',line_length,num);
end

% Check if length is a close enough match.
if ~toleranceCheck(line_length,maxLen,length_tolerance)
    % length not close enough
    if showMsgs
        fprintf('length not close enough to % f\n',maxLen);
    end
    return;
end

% Checks to filter false negatives

% Step 2: check number of participating points. Against false positives.
% if num < nmin
%     % not enough points
%     if showMsgs
%         fprintf('not enough points\n');
%     end
%     return;
% end

% Step 4: remove outliers and check if many points are outliers. Check
% against points whose end-points form lines but which are not lines.
% id = left;
% outliers = [];
% while id ~= right
%     id = ri.indexAdd(id,1);
%     err = distToLine2D([ri.xArray(id) ri.yArray(id)],line);
%     if err > member_thresh
%         outliers(end+1) = id;
%     end
% end
% num_outliers = length(outliers);
% if showMsgs
%     fprintf('% d outliers\n',num_outliers);
% end
% if (num_outliers/num) >= outlier_fraction
%     if showMsgs
%         fprintf('outliers are % f fraction of total points, ignoring model',(num_outliers/num));
%     end
%     return;
% end
% num = num-num_outliers;
% if num < nmin
%     if showMsgs
%         fprintf('not enough points after removing outliers\n');
%     end
%     return;
% end

% Step 5: find average point error. Threshold against large errors.
% id = left;
% while id ~= right
%     id = ri.indexAdd(id,1);
%     if ismember(id,outliers)
%         continue;
%     end
%     error = error+distToLine2D([ri.xArray(id) ri.yArray(id)],line);
% end
% error = error/num;
% if showMsgs
%     fprintf('average point error: % f\n',error);
% end
% if error > error_thresh
%     % average error too large
%     if showMsgs
%         fprintf('error larger than threshold % f\n',error_thresh);
%     end
%     return;
% end


p1 = [ri.xArray(left); ri.yArray(left)];
p2 = [ri.xArray(right); ri.yArray(right)];
line = ParametrizePts2ABC(p1,p2);

th = atanLine2D(line(1),line(2));
if showMsgs
    fprintf('theta % f\n',rad2deg(th));
end

res = struct('error',error,'th',th,'num',num,'left',left,'right',right);
end
