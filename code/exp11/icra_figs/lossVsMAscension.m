in.source = 'ascension-tracker';
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150831';
in.index = '';
fname = buildDataFileName(in);

load(fname);

%% true histogram
xc = getHistogramBins(sensor);
histDistance = @histDistanceMatch;
id = 40;%randsample(1:length(ZTrain),1);
z = ZTrain{id};
h = ranges2Histogram(z,xc);
bar(xc,h);
title(sprintf('id: %d',id));

%% 
MArray = floor(linspace(30,length(z),10));
nDraws = 5;
err = zeros(length(MArray),nDraws);
for i = 1:length(MArray)
    M = MArray(i);
    for j = 1:nDraws
        z_j = z(randsample(1:length(z),M));
        hEst = ranges2Histogram(z_j,xc);
        err(i,j) = histDistance(h,hEst);
    end
end

%% plot stuff
fs = 15;
errorbar(MArray,mean(err,2),std(err,0,2),'b.-','linewidth',3);
xlabel('M','fontsize',fs); ylabel('l(h,$\hat{h}$)','interpreter','latex','fontsize',fs);
ylim([0 3]);
xl = xlim;
hold on;
plot([xl(1) xl(2)],[0.5 0.5],'g--','linewidth',2);
box on;
grid on;