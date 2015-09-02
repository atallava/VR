n = 5e2;
readings = cell(1,n);

%%
t1 = tic();
fread(pingObj,pingObj.BytesAvailable);
for i = 1:n
	readings{i} = fscanf(pingObj);
	pause(0.01);
end
readings = {readings};
fprintf('Elapsed time: %.2fs\n',toc(t1));

%%
obsArray = pingRanges2ObsArray(readings);
fname = 'data_1';
save(fname,'obsArray');

%%
ranges = obsArray{1};
minRange = 3;
maxRange = max(max(ranges),313);
resn = 1;
bins = minRange:resn:maxRange;
ranges(ranges < minRange) = minRange;
h0 = hist(ranges,bins);
h0 = h0/sum(h0);
bar(bins,h0);
xlabel('bins');
ylabel('probability');
