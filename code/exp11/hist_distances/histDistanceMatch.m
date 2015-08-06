function d = histDistanceMatch(h1,h2)
% Match histogram distance

ch1 = cumsum(h1);
ch2 = cumsum(h2);
d = sum(abs(ch1-ch2));
end