%probe squared error

%% mean squared error
% hack that throws away one really bad pixel
seTest(:,:,4) = [];
nanIds = isnan(seTest);
validIds = ~nanIds;
validSE = seTest; validSE(nanIds) = 0;
avgSE = sum(validSE(:))/sum(~nanIds(:));
numNans = sum(nanIds(:));

%% collapse to parameters and pixels
twoSE = squeeze(sum(seTest,1))/size(seTest,1);
nParams = size(twoSE,1);
outlierPixels = cell(1,nParams);
nanPixels = cell(1,nParams);
pixelIds = rad2deg(rh.bearings)+1;
for i = 1:nParams
    nanIds = isnan(twoSE(i,:));
    data = twoSE(i,~nanIds);
    labels = {pixelIds(~nanIds)};
    nanPixels{i} = pixelIds(nanIds);
    outlierPixels{i} = outlierDiagnostic(data,labels);
end

%% collapse to pixels
pixelSE = squeeze(sum(validSE,1));
pixelSE = squeeze(sum(pixelSE,1));
pixelSE = pixelSE./sum(squeeze(sum(validIds,1)),1);

%% collapse to parameters
paramSE = squeeze(sum(validSE,1));
paramSE = squeeze(sum(paramSE,2));
paramSE = paramSE./sum(squeeze(sum(validIds,1)),2);
paramRMSE = sqrt(paramSE);

