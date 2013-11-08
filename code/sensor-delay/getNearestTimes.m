function t = getNearestTimes(t1,t2)
%t1, t2 are strictly increasing arrays
%for each element of t2, t contains that element of t1 >= to it

t = arrayfun(@(x) nearest(t1,x),t2);

end

function val = nearest(t, query)
ids = find(t <= query);
val = t(ids(end));
end

