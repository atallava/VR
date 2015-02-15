%
nConfs = 50;
scans = cell(1,nConfs);
load data_sep21_1
obsArray = fillObsArray(lzr,t_range_collection);
for i = 1:10
    scans{i} = rangesFromObsArray(obsArray,i,1:30);
end

load data_sep21_2
obsArray = fillObsArray(lzr,t_range_collection);
for i = 1:10
    scans{i+10} = rangesFromObsArray(obsArray,i,1:30);
end

load data_sep21_4
obsArray = fillObsArray(lzr,t_range_collection);
for i = 1:20
    scans{i+20} = rangesFromObsArray(obsArray,i,1:30);
end

load data_sep21_5
obsArray = fillObsArray(lzr,t_range_collection);
for i = 1:10
    scans{i+40} = rangesFromObsArray(obsArray,i,1:30);
end

%% 
save('scans_real','scans');