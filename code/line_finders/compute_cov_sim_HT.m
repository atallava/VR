% compute covariance in line parameters of line found in simulated data
% using findLinesHT.m

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
    lines = findLinesHT(ranges,4,0);
    if isempty(lines)
        fprintf('no line found for data %i\n',i);
        failure = failure+1;
        continue;
    end
    % th is theta in the polar paramters (r, theta) of a line
    th = lines(2,:);
    % get line closest to real line
    [~,closest] = min(abs(abs(th)-pi));
    if ~toleranceCheck(abs(th(closest)),pi,tolerance)
        fprintf('line not close enough to pi for data %i\n',i);
        failure = failure+1;
        continue;
    end
    params_rth(:,end+1) = lines(:,closest);
end