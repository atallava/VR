function res = sampleFromParamArray(paramArray,fitName)
% sample from the pdf indicated by fitName using params in paramArray
% paramArray is parameters x pixels
% fitName is a string

nPix = size(paramArray,2);

res = zeros(1,nPix);
for i = 1:nPix
    tempObj = feval(fitName,paramArray(:,i),1);
    res(i) = tempObj.sample();
end

end

