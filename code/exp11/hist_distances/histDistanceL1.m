function d = histDistanceL1(h1,h2)
% Euclidean histogram distance.

% unroll histograms
h1 = h1(:); h2 = h2(:);

d = norm(h1-h2,1);
end