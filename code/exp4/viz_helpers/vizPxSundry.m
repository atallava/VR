function vizPxSundry(dp,poseId,pxId)
%vzPxSundry view real range histogram vs fit pdf for training data
% dp is a dataProcessor object
% trainPose is index to dp.trainPoseIds
% pxId is index to pixel in dp.obsArray

ranges = dp.obsArray{poseId,pxId};
figure;
subplot(3,1,1);
plot(ranges,'+');
[hgram,xcenters] = ranges2Histogram(ranges,dp.laser);
hgram = hgram/sum(hgram);
title('real data');
%figure; 
subplot(3,1,2);
bar(xcenters,hgram);
title('histogram');
tempObj = normWithDrops(struct('vec',ranges));
pmfSim = tempObj.snap2PMF(xcenters);
%figure;
subplot(3,1,3);
bar(xcenters,pmfSim);
title('predicted pmf');
fprintf('nll: %f \n', tempObj.nll);
fprintf('pzero: %f\n',tempObj.pZero);

end

