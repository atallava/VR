function vizPxSundry(dp,trainPose,pxId)
%vzPxSundry view real range histogram vs fit pdf for training data
% dp is a dataProcessor object
% trainPose is index to dp.trainPoseIds
% pxId is index to pixel in dp.obsArray

poseId = dp.trainPoseIds(trainPose);
ranges = dp.obsArray{poseId,pxId};
figure;
plot(ranges,'+');
[hgram,xcenters] = ranges2Histogram(ranges,dp.laser);
hgram = hgram/sum(hgram);
title('real data');
figure;
bar(xcenters,hgram);
title('histogram');
tempObj = normWithDrops(ranges,0);
pmfSim = tempObj.snap2PMF(xcenters);
figure;
bar(xcenters,pmfSim);
title('predicted pmf');
fprintf('calculated nll: %f \n', tempObj.nll);

end

