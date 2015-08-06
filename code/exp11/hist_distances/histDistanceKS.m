function d = histDistanceKS(h1,h2)
% Kolmogoroff-Smirnoff histogram distance.

ch1 = cumsum(h1);
ch2 = cumsum(h2);
d = max(abs(ch1-ch2));
end