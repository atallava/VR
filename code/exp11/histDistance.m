function d = histDistance(h1,h2)
% currently KL distance

x = (h1+eps)./(h2+eps);
d = sum(h1.*log(x));
end