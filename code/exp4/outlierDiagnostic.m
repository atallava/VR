function outliers = outlierDiagnostic(dataMat,labels)
%errorDiagnostic throws up possible outliers
% labels is a cell array where labels{i} contains labels for the i-th
% dimension of dataMat
% outliers is an array of dimension nOutliers x dim of data containing
% outlier coordinates

mu = mean(dataMat(:));
sigma = std(dataMat(:));
ids = find((dataMat >= mu+sigma) | (dataMat <= mu-sigma));
nDims = length(labels);
subs = cell(1,nDims);
[subs{:}] = ind2sub(size(dataMat),ids);
nOutliers = length(subs{1});
outliers = zeros(nOutliers,nDims);

temp = zeros(1,nDims);
for i = 1:nOutliers
    for j = 1:nDims
        temp(j) = labels{j}(subs{j}(i));
    end
    outliers(i,:) = temp;
end

end

