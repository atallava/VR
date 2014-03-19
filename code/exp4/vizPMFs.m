function hfig = vizPMFs(rh,poseId,pmfPixel,params,fitName)
%vizPMFs visualize real and simulated pmfs
% rh: range histogram object

hfig = figure;
pixelIds = rad2deg(rh.bearings)+1;
subplot(2,1,1);
pmfReal = rh.H(poseId,:,pmfPixel);
pmfReal = pmfReal/sum(pmfReal);
bar(rh.xCenters,pmfReal);
title('real pmf');
subplot(2,1,2);
tempObj = feval(fitName,params,1);
pmfSim = tempObj.snap2PMF(rh.xCenters);
bar(rh.xCenters,pmfSim);
title('predicted pmf');
suptitle(sprintf('pixel %d',pixelIds(pmfPixel)));

end

