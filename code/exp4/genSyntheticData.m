%generate a synthetic dataset

clear all; clc; 
load processed_data_mar27
load map
nPoses = size(poses,2);
obsArray = cell(nPoses,360);

% obsArray
for i = 1:nPoses
    temp = roomLineMap.raycast(poses(:,i),4.5,deg2rad(0:359));
    temp = repmat(temp,[2 1]);
    for j = 1:360
        obsArray{i,j} = temp(:,j);
    end
end  

% range histograms
skip = 36;
pixelIds = 1:36:360;
nPixels = length(pixelIds);
input = struct('nPixels',nPixels,'nPoses',nPoses,'bearings',deg2rad(pixelIds-1));

rh = rangeHistograms(input);
for i = 1:nPoses
    for j = 1:nPixels
        px = pixelIds(j);
        rh.fillHistogram(i,j,obsArray{i,px});
    end
end
     
save('synthetic_data_mar27.mat','poses','obsArray','rh');