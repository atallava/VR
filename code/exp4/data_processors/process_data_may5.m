%process march 27 collected data
clear all; clc;
init;
load data_may5_peta

tCommonEnc = enc.tArray;
tCommonEnc = tCommonEnc-tCommonEnc(1);
tCommonLzr = lzr.tArray;
tCommonLzr = tCommonLzr-tCommonLzr(1);
nPoses = length(id_range_collection);
for i = 1:length(id_range_collection)
    t_range_collection(i).start = tCommonEnc(id_range_collection(i).start);
    t_range_collection(i).end = tCommonEnc(id_range_collection(i).end);
end

%% fill observation array
pixelIds = [1:30 331:360];
bearings = deg2rad(pixelIds-1);
nPixels = length(pixelIds);
obsArray = cell(nPoses,nPixels);

for i = 1:nPoses
    ids = find(tCommonLzr >= t_range_collection(i).start & tCommonLzr <= t_range_collection(i).end);
    temp = lzr.rangeArray(ids);
    temp = cell2mat(temp');
    for j = 1:nPixels;
        obsArray{i,j} = temp(:,pixelIds(j));
    end    
end

laser = laserClass(struct('maxRange',5,'bearings',bearings));
%save('processed_data_may5.mat','obsArray','laser');
%ids(1) = [100 343 747 1108 1469]

%% viz data
close all; clear all; clc;
load processed_data_may5
nPoses = size(obsArray,1);
inputStruct = struct('poses',1:nPoses,'obsArray',{obsArray},'laser',laser,'trainPoseIds',1:nPoses,'testPoseIds',[]);
dp = dataProcessor(inputStruct);

for i = 1:nPoses
    fprintf('pose %d\n',i);
    for j = 1:dp.laser.nPixels
        if max(obsArray{i,j}) > 10
            fprintf('bearing %f\n',rad2deg(dp.laser.bearings(j)));
        end
    end
end





