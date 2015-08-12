function d = histDistanceJeffrey(h1,h2)
% KL histogram distance.

h1 = h1+eps; h1 = h1/sum(h1);
h2 = h2+eps; h2 = h2/sum(h2);
h3 = 0.5*(h1+h2);
d = sum(h1.*log(h1./h3)+h2.*log(h2./h3));
end