function res = lineCandBaseline(rangeImage_obj,middle,maxLen,showMsgs)
% assumes that ranges have been restricted to a certain min and
% max range


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

error = 0; th = 0;

left = middle;
right = middle;
while true
    line_length = norm([rangeImage_obj.xArray(left)-rangeImage_obj.xArray(right) ...
        rangeImage_obj.yArray(left)-rangeImage_obj.yArray(right)]);
    if line_length > maxLen
        break;
    end
    left = rangeImage_obj.indexAdd(left,-1); right = rangeImage_obj.indexAdd(right,1);
end
left = rangeImage_obj.indexAdd(left,1);
right = rangeImage_obj.indexAdd(right,-1);
line_length = norm([rangeImage_obj.xArray(left)-rangeImage_obj.xArray(right) ...
    rangeImage_obj.yArray(left)-rangeImage_obj.yArray(right)]);
if right > left
    num = (right-left)+1;
else
    num = (rangeImage_obj.nPix-left)+1+right;
end
if showMsgs
    fprintf('middle: % d, left: % d, right: % d\n',middle,left,right);
    fprintf('length: % f, number of points: % f\n',line_length,num);
end
if num < nmin
    % not enough points
    if showMsgs
        fprintf('not enough points\n');
    end
    return;
end
if ~toleranceCheck(line_length,maxLen,length_tolerance)
    % length not close enough
    if showMsgs
        fprintf('length not close enough to % f\n',maxLen);
    end
    return;
end

p1 = [rangeImage_obj.xArray(left); rangeImage_obj.yArray(left)];
p2 = [rangeImage_obj.xArray(right); rangeImage_obj.yArray(right)];
line = ParametrizePts2ABC(p1,p2);

% remove outliers
id = left;
outliers = [];
while id ~= right
    id = rangeImage_obj.indexAdd(id,1);
    err = distToLine2D([rangeImage_obj.xArray(id) rangeImage_obj.yArray(id)],line);
    if err > member_thresh
        outliers(end+1) = id;
    end
end
num_outliers = length(outliers);
if showMsgs
    fprintf('% d outliers\n',num_outliers);
end
if (num_outliers/num) >= outlier_fraction
    if showMsgs
        fprintf('outliers are % f fraction of total points, ignoring model',(num_outliers/num));
    end
    return;
end
num = num-num_outliers;
if num < nmin
    if showMsgs
        fprintf('not enough points after removing outliers\n');
    end
    return;
end

% compute average point error
id = left;
while id ~= right
    id = rangeImage_obj.indexAdd(id,1);
    if ismember(id,outliers)
        continue;
    end
    error = error+distToLine2D([rangeImage_obj.xArray(id) rangeImage_obj.yArray(id)],line);
end
error = error/num;
if showMsgs
    fprintf('average point error: % f\n',error);
end
if error > error_thresh
    % average error too large
    if showMsgs
        fprintf('error larger than threshold % f\n',error_thresh);
    end
    return;
end

th = atanLine2D(line(1),line(2));
if showMsgs
    fprintf('theta % f\n',rad2deg(th));
end

res = struct('error',error,'th',th,'num',num,'left',left,'right',right);
end
