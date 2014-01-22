% compute covariance in line parameters of line found in experimental data
% using getLinesSimple.m

load ~/VR/calibration/data_12Jan.mat

failure = 0;
tolerance = deg2rad(5);
params_rth = [];
for i = 1:size(readings_full_line1,2)
    ranges = rangeImage(readings_full_line1(:,i),1,1);
    lines = getLinesSimple(ranges,0.61,0);
    if isempty(lines)
        fprintf('no line found for data %i\n',i);
        failure = failure+1;
        continue;
    end
    % th is the angle the line makes with the x-axis
    th = arrayfun(@(x) lines{x}(2),1:length(lines));
    % get line closest to real line
    [~,closest] = min(abs(abs(th)-pi/2));
    if ~toleranceCheck(th(closest),pi/2,tolerance)
        fprintf('line not close enough to pi/2 for data %i\n',i);
        failure = failure+1;
        continue;
    end
    line = lines{closest};
    left = line(end-1); right = line(end);
    params_abc = ParametrizePts2ABC([ranges.xArray(left) ranges.yArray(left)],[ranges.xArray(right) ranges.yArray(right)]);
    params_rth(:,end+1) = ParametrizeABC2Rth(params_abc);
end

params_rth(2,:) = mod(params_rth(2,:),pi);
