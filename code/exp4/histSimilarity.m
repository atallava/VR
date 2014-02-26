function res = histSimilarity(h1,h2)
% histogram intersection similarity between two histograms h1 and h2

h1 = h1/sum(h1);
h2 = h2/sum(h2);
res = sum(bsxfun(@min,h1,h2));

end

