addpath ../../ascension_tracker/

reading0 = 8.25;
magicFactor = 2.54;
minZ = -5;
maxZ = 25;
resn = 0.1;
bins = minZ:resn:maxZ;

%% static 
fname = 'data_ascension_static';
data = parseAscensionData(fname);
readings = [data.x];
z1 = magicFactor*(readings-reading0);
z1(z1 < minZ) = minZ;
h1 = hist(z1,bins);
h1 = h1/sum(h1);

%% dynamic
fname = 'data_ascension_dynamic';
data = parseAscensionData(fname);
readings = [data.x];
z2 = magicFactor*(readings-reading0);
z2(z2 < minZ) = minZ;
h2 = hist(z2,bins);
h2 = h2/sum(h2);

%% plot stuff
yl = [0 0.25];
xl = [-5 5];

figure;
bar(bins,h1);
xlim(xl); ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

figure;
bar(bins,h2);
xlim(xl); ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);
