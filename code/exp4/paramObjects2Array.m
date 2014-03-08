function paramArray = paramObjects2Array(fitArray)
% convert an array of objects into a parameter array
% fitArray is cell array of size training poses x pixels
% paramArray is array of size training poses x fit parameters x pixels

nPoses = size(fitArray,1);
nPixels = size(fitArray,2);
nParams = fitArray{1}.nParams;
paramArray = zeros(nPoses,nParams,nPixels);

for i = 1:nPoses
    for j = 1:nPixels
        paramArray(i,:,j) = fitArray{i,j}.getParams();
    end
end

end

