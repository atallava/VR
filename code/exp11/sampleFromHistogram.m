function samples = sampleFromHistogram(h,xc,n)
%SAMPLEFROMHISTOGRAM Draw one or more samples from one or more histograms
% 
% samples = SAMPLEFROMHISTOGRAM(h,xc,n)
% 
% h       - N x R array. N histograms, each with R bins.
% xc      - N x R array. Centers for histograms. N = 1 implies shared
%           centers
% n       - Number of samples. Defaults to 1.
% 
% samples - n x N samples.


if nargin < 3
    n = 1;
end

nH = size(h,1);
if size(xc,1) < nH
    xc = repmat(xc,nH,1);
end

cdfs = cumsum(h,2);
samples = zeros(n,nH);

for i = 1:n
    for j = 1:nH
        z = rand();
        id = sum(cdfs(j,:) <= z)+1;
        if id > length(cdfs(j,:))
            samples(i,j) = 0;
        else
            samples(i,j) = xc(j,id);
        end
    end
end

end