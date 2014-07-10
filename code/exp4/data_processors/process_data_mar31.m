%process march 31 collected data
clear all; clc;
load data_mar31_peta
addpath ~/Documents/MATLAB/neato_utils/

nData = lzr.update_count;
tCommonEnc = enc.tArray;
tCommonEnc = tCommonEnc-tCommonEnc(1);
tCommonLzr = lzr.tArray;
tCommonLzr = tCommonLzr-tCommonLzr(1);

%% fill observation array
ids = linspace(1,60*200,60);
ids = floor(ids);
obsArray = cell(60,360);

for i = 1:60
    temp = lzr.rangeArray(ids(i):ids(i)+200);
    temp = cell2mat(temp');
    for j = 1:360
        obsArray{i,j} = temp(:,j);
    end    
end