function d = histDistanceMomentMatch(h1,h2,xc)
    if isrow(h1); h1 = h1'; end
    if isrow(h2); h2 = h2'; end
    numMoments = 3;
    res = histStat(xc,[h1 h2],numMoments);
    res = cell2mat(res');
    d = sum(norm(res(:,1)-res(:,2)));
end