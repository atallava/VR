%% generate poses from encoder readings
% very flimsy currently. no filtering
clear all; clear classes; clc;

load data_Feb7
nPoses = length(data);
poses = zeros(3,nPoses);

addpath ~/Documents/MATLAB/neato_utils/
rstate = robState(1,'manual',[0;0;0]);

for i = 1:nPoses
    m = length(data(i).u);
    for j = 2:m
        rstate.setEncoders(data(i).u(j),(j-2)/30);
    end
    poses(:,i) = rstate.pose;
    rstate.reset(poses(:,i));
end

%% generate observation array
% obsArray has all observed ranges
% obsArray is of size poses x observations x pixels
nObs = size(data(1).z,2);

obsArray = zeros(nPoses,nObs,360);

for i = 1:nPoses
    obsArray(i,:,:) = data(i).z(:,:)';
end

%% downsample range data and put into histogram
% save processed data
skip = 36;
ranges = {};
pixelIds = 1:36:360;
nPixels = length(pixelIds);
bearings = deg2rad(pixelIds-1);

rh = rangeHistograms(nObs,nPixels,nPoses,bearings);
for i = 1:nPoses
    for j = 1:nPixels
        px = pixelIds(j);
        rh.fillHistogram(i,j,data(i).z(px,:));
    end
end

save('processed_data.mat','poses','rh','obsArray');
%% plot poses sequentially

close all;
hp = plot(poses(1,1),poses(2,1),'+');
xlim([0 3.66])
ylim([0 1.83]);
axis equal; hold on;

for i = 2:nPoses
    waitforbuttonpress;
    set(hp,'XData',[get(hp,'XData') poses(1,i)]);
    set(hp,'YData',[get(hp,'YData') poses(2,i)]);    
end