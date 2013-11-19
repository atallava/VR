function hfig = plotData(d,mu,sd)
%mu represents means at x-points
%sd represents stds at x-points
%all vectors

hfig = figure;
scatter(d,mu,5,'b')';
hold on
sd_pts = arrayfun(@(i) [d(i) mu(i)+sd(i); d(i) mu(i)-sd(i)], 1:length(d),'uni',0);
arrayfun(@(i) plot(sd_pts{i}(:,1), sd_pts{i}(:,2), 'r'),1:length(d));
xlabel(gca,'distance'); ylabel(gca,'error');
end

