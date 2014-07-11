function scans = scansFromMuArray(muArray)
% for localMatch, need scans. this function helps take those from an array
% of mean ranges
% muArray is nPoses x nPixels
scans = cell(1,size(muArray,1));
for i = 1:size(muArray,1)
    scans{i} = muArray(i,:);
end
end

