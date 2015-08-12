function lims = selectBwLims(vec)
% select upper and lower bounds for bandwidth search

if isrow(vec); vec = vec'; end
d = pdist2(vec,vec);
d = d(:);
d = unique(sort(d));
lims(1) = quantile(d,0.01);
lims(2) = quantile(d,0.5);
end