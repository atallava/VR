% compute covariance in line parameters of line found in simulated data
% using getLinesSimple.m

load ~/neato_matlab/environments/square_walls.mat

plank = lineObject;
plank.lines = [0 0; 0.61 0];
plank.pose = [0.305;.305;pi/2];
square_walls.addObject(plank);

failure = 0;
tolerance = deg2rad(5);
params_rth = [];
for i = 1:100
    ranges = rangeImage(square_walls.raycastNoisy([0.71;0.61;0],4,0:359),1,1);
    lines = getLinesSimple(ranges,0.61,0);
    if isempty(lines)
        fprintf('no line found for data %i\n',i);
        failure = failure+1;
        continue;
    end
    th = arrayfun(@(x) lines{x}(2),1:length(lines));
    % get line closest to real line
    [~,closest] = min(abs(th-pi/2));
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