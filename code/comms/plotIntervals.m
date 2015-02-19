function hf = plotIntervals(ivl1,ivl2,title1,title2)
%PLOTINTERVALS Plot two histograms as subplot.
% 
% hf = PLOTINTERVALS(ivl1,ivl2,title1,title2)
% 
% ivl1   - Interval array 1.
% ivl2   - Interval array 2.
% title1 - String, optional.
% title2 - String, optional.
% 
% hf     - Figure handle.

if (nargin < 3)
	title1 = 'histogram 1';
	title2 = 'histogram2';
end

minVal = min([ivl1 ivl2]);
maxVal = max([ivl2 ivl2]);
xbins = linspace(minVal,maxVal,20);

hf = figure;
subplot(2,1,1);
hist(ivl1,xbins);
xlabel('interval (s)');
ylabel('data count');
title(title1);
subplot(2,1,2);
hist(ivl2,xbins);
ylabel('data count');
xlabel('interval (s)');
title(title2);
end

