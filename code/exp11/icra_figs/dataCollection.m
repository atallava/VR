% for page 1 fig explaining the problem

xc = 0:0.1:5;
oddIds = 1:4:length(xc);

%% corner looking
mu = 0.5;
sigma = 0.1;
pz = 0;
model = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h11 = model.snap2PMF(xc);

mu = 3;
sigma = 0.2;
pz = 0;
model = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h12 = model.snap2PMF(xc);

mixing = 0.6;
h1 = mixing*h11+(1-mixing)*h12;
h1(oddIds) = 0;

hf1 = figure;
bar(xc,h1);
ylim([0 0.25]);
axis off

%% large range
mu = 4;
sigma = 0.4;
pz = 0;
model = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h11 = model.snap2PMF(xc);

mu = 1;
sigma = 0.1;
pz = 0;
model = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h12 = model.snap2PMF(xc);

mixing = 0.9;
h1 = mixing*h11+(1-mixing)*h12;
h1(oddIds) = 0;

hf2 = figure;
bar(xc,h2);
ylim([0 0.25]);
axis off
