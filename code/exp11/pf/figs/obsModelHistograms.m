% npreg hist
% load ../data/npreg_didnt_2
load ../data/thrun_failed_2

B = length(obsModelStruct.ranges);
id = 1;
xc = obsModelStruct.sensor.readingsSet();
hParticle = obsModelStruct.h((id-1)*B+1:id*B,:);
bearingId = 10;
ylim([0 2.5e-3]);
xlim([0 5]);

% histogram
bar(xc,hParticle(bearingId,:));
% mark locations of nominal and observed readings
binObserved = 2.338;
binNominal = 3.404;
hold on;
plot([binObserved binObserved],[0 2.5e-3],'--','linewidth',1.5,'color',[1 0 0]);
plot([binNominal binNominal],[0 2.5e-3],'--','linewidth',1.5,'color',[0 0.7 0]);

% axes font size
fs = 15;
set(gca,'FontSize',fs);

xlabel('z','fontsize',fs);
ylabel('$\hat{h}$','interpreter','latex','fontsize',fs);

