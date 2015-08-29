% just plot some histograms
fname = 'data_3';
load(fname);

%% true histogram
minRange = 3;
maxRange = 313;
bins = 3:313;
ranges(ranges < minRange) = minRange;
h0 = hist(ranges,bins);
h0 = h0/sum(h0);
bar(bins,h0);
xlabel('bins');
ylabel('probability');

%% approximations
n = linspace(100,length(ranges),10);
n = floor(n);
draws = 10;
err = zeros(length(n),draws);
for i = 1:length(n)
	for j = 1:draws
		subRanges = randsample(ranges,n(i));
		hSub = hist(subRanges,bins);
		hSub = hSub/sum(hSub);
		err(i,j) = norm(h0-hSub);
	end
end

%% plot stuff
errorbar(n,mean(err,2),std(err,0,2),'.-');
xlabel('n train');