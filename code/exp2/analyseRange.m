function [th_bins,d,mu,sd,c] = analyseRange(i)
%analyse variation with respect to range for return index i
%for each bin in th_bins, returns unique ranges, means and stdevs

if ~exist('errors','var')
    load('processed_data2.mat');
end
e = errors{i};
thmax = max(e(:,2)); thmin = min(e(:,2));
th_bins = thmin:deg2rad(0.5):thmax;
ids = arrayfun(@(x) find(e(:,2) >= th_bins(x) & e(:,2) < th_bins(x+1)), 1:(numel(th_bins)-1),'uni',0);
nbins = arrayfun(@(x) size(ids{x},1), 1:size(ids,2)); %number of entries in each bin
m = mean(nbins);
rem_ids = nbins < m; %ids2 could be source of information
%throw away bins with less than m points 
th_bins(rem_ids) = []; th_bins(end) = [];
ids(rem_ids) = []; 
nbins(rem_ids) = [];

[d, mu, sd] = arrayfun(@(x) getSomeParams(e,ids,x), 1:length(ids), 'uni', 0);
nd = arrayfun(@(x) size(d{x},1), 1:length(d)); %number of unique ranges in each bin
ids2 = find( nd >= 3 & nd <= 7);
c = arrayfun(@(x) fitQuadratic(d{x},mu{x}), ids2, 'uni', 0);
end

function [d, mu, sd] = getSomeParams(e,ids,j)
%this function is passed data corresponding to theta bin j
%d is an array of unique true ranges
%mu is an array of means at the corresponding d
%sd is an arrat of std at the corresponding d

d = unique(e(ids{j},1));
%get which ids correspond to distance d
partition = arrayfun(@(x) ids{j}(e(ids{j},1) == x), d, 'uni',0);
mu = cellfun(@(x) mean(e(x,4)), partition);
sd = cellfun(@(x) std(e(x,4)), partition);
end

function c = fitQuadratic(d,mu)
%fit quadratic given ranges and means
A = [ones(length(d),1) d d.^2];
c = (A'*A)\(A'*mu);
end

