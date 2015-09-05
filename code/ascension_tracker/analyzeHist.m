% just plot some histograms
fname = 'data_ascension_dynamic';
data = parseData(fname);

%% true histogram
load parameters_150831
readings = [data.x];
reading0 = 8.25;
z = magicFactor*(readings-reading0);
minZ = -5;
maxZ = 25;
% minZ = min(z);
% maxZ = max(z);
resn = 0.1;
bins = minZ:resn:maxZ;
z(z < minZ) = minZ;
h0 = hist(z,bins);
h0 = h0/sum(h0);
bar(bins,h0);
xlabel('bins');
ylabel('prob');
ylim([0 0.25]);

%% approximations
n = linspace(100,length(z),10);
n = floor(n);
draws = 10;
err = zeros(length(n),draws);
for i = 1:length(n)
	for j = 1:draws
		subRanges = randsample(z,n(i));
		hSub = hist(subRanges,bins);
		hSub = hSub/sum(hSub);
		err(i,j) = norm(h0-hSub);
	end
end

%% plot stuff
errorbar(n,mean(err,2),std(err,0,2),'.-');
xlabel('n train');
ylabel('histogram error');