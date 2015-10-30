% for regression flowchart 
xcLims = [0 5];
resn = 0.1;
resnFine = 0.001;
xc = xcLims(1):resn:xcLims(2);
xcFine = xcLims(1):resnFine:xcLims(2);
oddIds = 1:4:length(xc);
lw = 3;
yl = [0 0.2];

%% histogram 1
mu = 2.8;
sigma = 0.3;
pz = 0;
model1 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h1 = model1.snap2PMF(xc);

hf1 = figure;
bar(xc,h1);
ylim(yl);
axis off

%% histogram 2
mu = 2.5;
sigma = 0.2;
pz = 0;
model21 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h21 = model21.snap2PMF(xc);

mu = 1.6;
sigma = 0.3;
pz = 0;
model22 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h22 = model22.snap2PMF(xc);

mixing = 0.8;
h2 = mixing*h21+(1-mixing)*h22;

hf2 = figure;
bar(xc,h2);
ylim(yl);
axis off

%% histogram 3
mu = 2.3;
sigma = 0.2;
pz = 0;
model31 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h31 = model31.snap2PMF(xc);

mu = 1.1;
sigma = 0.23;
pz = 0;
model32 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
h32 = model32.snap2PMF(xc);

mixing = 0.7;
h3 = mixing*h31+(1-mixing)*h32;

hf3 = figure;
bar(xc,h3);
ylim(yl);
axis off

%% DE by preg
figure;
h1 = model1.snap2PMF(xc);
bar(xc,cutH(h1,oddIds));
hold on;
plot(xcFine,interp1(xc,h1,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

mu = 2.25;
sigma = 0.4;
pz = 0;
modelPReg2 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
hPReg2 = modelPReg2.snap2PMF(xc);
figure;
% bar(xc,h2); 
% hold on;
plot(xcFine,interp1(xc,hPReg2,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

mu = 1.8;
sigma = 0.6;
pz = 0;
modelPReg3 = normWithDrops(struct('vec',[mu sigma pz],'choice','params'));
hPReg3 = modelPReg3.snap2PMF(xc);
figure;
bar(xc,cutH(h3,oddIds)); 
hold on;
plot(xcFine,interp1(xc,hPReg3,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

%% DE by dreg
figure;
bar(xc,cutH(h1,oddIds));
h1 = model1.snap2PMF(xc);
hold on;
plot(xcFine,interp1(xc,h1,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

mu = 2;
sigma = 0.5;
pz = 0;
figure;
% bar(xc,h2); 
% hold on;
plot(xcFine,interp1(xc,h2,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

mu = 1.8;
sigma = 0.5;
pz = 0;
figure;
bar(xc,cutH(h3,oddIds)); 
hold on;
plot(xcFine,interp1(xc,h3,xcFine,'spline'),'r','linewidth',lw);
ylim(yl);
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);






