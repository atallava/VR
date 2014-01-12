function [th_bins,m,s,ndata,r] = getDistribParams(error, bin_size)
%errors is a nx4 array of form [r th l error]
%l: board distance set
%divide range of th into bins of size bin_size
%th_bins: array of bin values
%m, s, ndata, r: mean, variance, number of data points in, range value in
%... each bin

thmax = max(error(:,2)); thmin = min(error(:,2));
th_bins = thmin:bin_size:thmax; th_bins(end) = [];
ids = arrayfun(@(x) find(error(:,2) >= th_bins(x) & error(:,2) < th_bins(x) + bin_size), 1:numel(th_bins),'uni', 0); %ids of entries in each bin
ndata = arrayfun(@(x) length(ids{x}), 1:length(ids)); %number of entries in each bin
zero_ids = find(ndata == 0); %bins with no returns;
ndata(zero_ids) = []; th_bins(zero_ids) = []; ids(zero_ids) = []; %throw away empty bins
nr = arrayfun(@(x) length(unique(error(ids{x},1))), 1:length(ids)); %number of unique range values in each bin
r = arrayfun(@(x) error(ids{x}(1),1), 1:length(ids)); % range values in each bin

m = arrayfun(@(x) mean(error(ids{x},4)), 1:length(ids)); %mean of each bin
s = arrayfun(@(x) var(error(ids{x},4)), 1:length(ids)); %variance of each bin


end

