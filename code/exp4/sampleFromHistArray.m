function samples = sampleFromHistArray(histArray,centers)
% histArray is ncenters x pixels
% samples is of length pixels

nPixels = size(histArray,2);
samples = zeros(1,nPixels);
for i = 1:nPixels
    samples(i) = sampleFromHist(histArray(:,i),centers);
end

end

