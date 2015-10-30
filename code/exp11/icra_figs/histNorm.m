xc = -1:.01:4;

%%
m1 = 2;
sigma = 0.05;
pZ = 0;
in.vec = [m1 sigma pZ];
in.choice = 'params';
params1 = normWithDrops(in);
h1 = params1.snap2PMF(xc);

%%
m2 = 2.2;
sigma = 0.05;
pZ = 0;
in.vec = [m2 sigma pZ];
in.choice = 'params';
params2 = normWithDrops(in);
h2 = params2.snap2PMF(xc);

%%
m31 = 1.9;
sigma = 0.1;
pZ = 0;
in.vec = [m31 sigma pZ];
in.choice = 'params';
params31 = normWithDrops(in);
h31 = params31.snap2PMF(xc);

m32 = 1.5;
sigma = 0.05;
pZ = 0;
in.vec = [m32 sigma pZ];
in.choice = 'params';
params32 = normWithDrops(in);
h32 = params32.snap2PMF(xc);

mix = 0.5;
h3 = mix*h31+(1-mix)*h32;

%%
e12euc = histDistanceEuclidean(h1,h2)
e13euc = histDistanceEuclidean(h1,h3)

e12match = histDistanceMatch(h1,h2)
e13match = histDistanceMatch(h1,h3)

%%
hList = {h1 h2 h3};
xl = [1 3];
yl = [0 0.1];
for i = 1:3
    subplot(3,1,i);
    bar(xc,hList{i});
    xlim(xl); ylim(yl);
    set(gca,'xtick',[]);
    set(gca,'xticklabel',[]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
end


%%
ch1 = cumsum(h1);
ch2 = cumsum(h2);
ch3 = cumsum(h3);
lw = 3;

figure; hold on;
plot(xc,ch1,'b','linewidth',lw);
plot(xc,ch2,'r','linewidth',lw);
ylim([-0.1 1.1]);
xlim([0 4]);
% legend({'1','2'});
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);

figure; hold on;
plot(xc,ch1,'b','linewidth',lw);
plot(xc,ch3,'r','linewidth',lw);
ylim([-0.1 1.1]);
xlim([0 4]);
% legend({'1','3'});
set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[]);
set(gca,'yticklabel',[]);





















