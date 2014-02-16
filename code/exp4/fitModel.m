function fitArray = fitModel(fitArray,fitName,trainIds)
% fitName is a string of the fit Class type

load data_Feb7;
load processed_data;

pixelIds = rad2deg(rh.bearings)+1;
for i = 1:length(trainIds)
    for j = 1:length(pixelIds)
        fitArray(i,j) = feval(fitName,data(trainIds(i)).z(pixelIds(j),:));
    end
end
end

