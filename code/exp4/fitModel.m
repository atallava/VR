function fitArray = fitModel(fitArray,fitName,trainIds)
% fitName is a string of the fit class type
% fitArray is an object array of size training poses x pixels

load processed_data;

pixelIds = rad2deg(rh.bearings)+1;
for i = 1:length(trainIds)
    for j = 1:length(pixelIds)
        data = squeeze(obsArray(trainIds(i),pixelIds(j),:));
        fitArray(i,j) = feval(fitName,data,0);
    end
end
end

