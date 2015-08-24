function d = histDistanceKL(h1,h2)
% KL histogram distance.

% unroll histograms
h1 = h1(:); h2 = h2(:);

h1 = h1+eps; h1 = h1/sum(h1);
h2 = h2+eps; h2 = h2/sum(h2);
d = sum(h1.*log(h1./h2));
end