function [outspace, fm,fs] = analyseTheta(e, l, plot_option)
%e: error of a particular return index, of form [r th l ...
%... error]
%l: board distance set
%looking at a subset of data
%fm, fs are polynomials fit to the mean and variance
%outspace is an array of size 2xnout of [th r]' values where outliers are

e(~(e(:,3) == l),:) = [];
bin_size = deg2rad(0.01);
[th_bins,m,s,ndata,r] = getDistribParams(e, bin_size);

outid = getOutliers([m' s' ndata'], 5, 0.3); %ad-hoc parameter values
outspace = [th_bins(outid); r(outid)];

deg = 2; %why? assuming symmetric and want enough expressivity
inids = setdiff(1:length(th_bins),outid);
fm = polyfit(th_bins(inids),m(inids),deg); %don't fit to outliers
fs = polyfit(th_bins(inids),s(inids),deg);

if plot_option ~= 0
    figure;
    scatter(th_bins, ndata,'r'); title(gca,sprintf('ndata, l: %d',l));
    hold on;
    plot(th_bins, ndata,'b');
    figure;
    scatter(th_bins, m,'r'); title(gca,sprintf('m, l: %d',l));     
    hold on;
    plot(th_bins, m,'b'); plot(th_bins, polyval(fm,th_bins), 'g');
    figure;
    scatter(th_bins, s,'r'); title(gca,sprintf('s, l: %d',l));
    hold on;
    plot(th_bins, s,'b'); plot(th_bins, polyval(fs,th_bins), 'g');
end

end