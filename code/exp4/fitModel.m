function fitArray = fitModel(fitName,obsArray,rh,trainIds)
% fitName is a string of the fit class type
% fitArray is a cell array of size training poses x pixels
% rh is an object of type rangeHistograms


pixelIds = rad2deg(rh.bearings)+1;
fitArray = cell(length(trainIds),length(pixelIds));
for i = 1:length(trainIds)
    for j = 1:length(pixelIds)
        data = squeeze(obsArray(trainIds(i),:,pixelIds(j)));
        data = squeeze(data);
        fitArray{i,j} = feval(fitName,data,0);
    end
end
end

