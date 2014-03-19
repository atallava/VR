% get baseline performance

%% initialize
load processed_data
load poses_from_range_matching
load map

poses = posesFromRangeMatching(:,1:20);
X = poses';
pixelIds = rad2deg(rh.bearings)+1;
fitParamArray = zeros(length(X),3,rh.nPixels);
rAlphaArray = poses2RangeAlpha(roomLineMap,X,rad2deg(rh.bearings));
baselineParamArray = zeros(length(poses),3,rh.nPixels);
K = 1e-3;
for i = 1:length(poses)
    for j = 1:rh.nPixels
        rr = obsArray(i,:,pixelIds(j));
        tempObj = normWithDrops(rr,0);
        fitParamArray(i,:,j) = tempObj.getParams();
        baselineParamArray(i,1,j) = rAlphaArray(i,1,j);
        sigma = K*rAlphaArray(i,1,j)/cos(rAlphaArray(i,2,j));
        baselineParamArray(i,2,j) = sigma;
    end
end
