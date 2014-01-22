% compute covariance in line parameters of line found in experimental data
% using findLinesHT.m

load('~/VR/calibration/data_12Jan.mat','readings_full_line1');

failure = 0;
tolerance = deg2rad(5);
params_rth = [];
for i = 1:size(readings_full_line1,2)
    ranges = rangeImage(readings_full_line1(:,i),1,1);
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