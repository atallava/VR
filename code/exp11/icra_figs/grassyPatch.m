load observations_dynamic

sensor = laserClass(struct());
xc = getHistogramBins(sensor);

%%
h1 = ranges2Histogram(rangeArray(:,5),xc);
figure;
bar(xc,h1);
xlim([0.68 1.15]);
ylim([0 0.06]);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);


h2 = ranges2Histogram(rangeArray(:,6),xc);
figure;
bar(xc,h2);
xlim([0.68 1.15]);
ylim([0 0.06]);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);


% 5 
% xl = [0.68 1.15];
% yl = [0 0.06];

% 35
% xl = [1 2];
% yl = [0 0.05];

% 46
% xl = [1.2 1.6];
% yl = [0 0.05];
