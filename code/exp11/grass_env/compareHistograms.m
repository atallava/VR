dStatic = load('observations_static');
dDynamic = load('observations_dynamic');
xc = getHistogramBins(laser);

%%
id = 353;%randsample(dStatic.ids,1);
h1 = hist(dStatic.rangeArray(:,id),xc); h1 = h1/sum(h1);
h2 = hist(dDynamic.rangeArray(:,id),xc); h2 = h2/sum(h2);

subplot(2,1,1);
bar(xc,h1);
xlabel('bins'); ylabel('probability');
title('static environment');
subplot(2,1,2);
bar(xc,h2);
title('dynamic environment');
xlabel('bins'); ylabel('probability');
suptitle(sprintf('bearing: %d',id-1));