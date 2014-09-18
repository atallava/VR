function [pxRegBundle,localPhiArray] = localRBundle(inputStruct,scans,matcher)
% create a pixel regressor bundle using inputstruct and locally matched
% scans. build the regressor array explicitly

pxRegBundle = pixelRegressorBundle(inputStruct);
nPoses = size(inputStruct.XTrain,1);
nPixels = size(inputStruct.YTrain,3);
localPhiArray = zeros(nPoses,2,nPixels);
for i = 1:nPoses
    ranges = scans{i};
    pose = inputStruct.XTrain(i,:);
    outIds = matcher.getOutIds(ranges,pose);
    inClusters = matcher.getInClusters(outIds);
    localPoses = matcher.getLocalPoses(ranges,inClusters,pose);
    temp = matcher.getLocalPhi(inClusters,localPoses);
    localPhiArray(i,:,:) = temp';
end

for i = 1:nPixels
    tempInput = inputStruct;
    tempInput.XTrain = squeeze(localPhiArray(:,:,i));
    tempInput.YTrain = inputStruct.YTrain(:,:,i);
    pxRegBundle.regressorArray{i} = inputStruct.regClass(tempInput);
end
end

