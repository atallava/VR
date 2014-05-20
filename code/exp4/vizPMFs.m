function hfig = vizPMFs(ranges,params,fitClass,laser)
%vizPMFs visualize real and simulated pmfs
% fitClass is a class handle
% laser is a laserClass object

hfig = figure;
subplot(2,1,1);
[pmfReal,xcenters] = ranges2Histogram(ranges,laser);
pmfReal = pmfReal/sum(pmfReal);
bar(xcenters,pmfReal);
title('real pmf');
subplot(2,1,2);
tempObj = fitClass(params,1);
pmfSim = tempObj.snap2PMF(xcenters);
bar(xcenters,pmfSim);
title('predicted pmf');
end