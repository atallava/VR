function samples = sampleFromHist(h,centers,n)
% draw n samples from centers with mass h

if nargin < 3
    n = 1; % single sample by default
end

if sum(h) == 0
   samples = nan(1,n);
   return;
end
   
h = h/sum(h);
cdf = h;
for i = 2:length(h)
    cdf(i) = h(i)+cdf(i-1);
end
samples = zeros(1,n);
for i = 1:n
    r = rand;
    ids = find(cdf > r);
    samples(i) = ids(1);
end
samples = centers(samples);
end

