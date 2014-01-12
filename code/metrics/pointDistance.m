function [D,false_hits,false_misses] = pointDistance(set1,set2)
% simple point distance metric for two range returns from the same environment and robot pose 
% set1 and set2 are rangeImage objects
% sets should not be cleaned up

misses1 = find(set1.rArray == 0);
misses2 = find(set2.rArray == 0);

false_hits = setdiff(misses2,misses1);
false_misses = setdiff(misses1,misses2);

valid1 = setdiff(1:set1.npix,misses1);
valid2 = setdiff(1:set2.npix,misses2);
points1 = [set1.xArray(valid1)' set1.yArray(valid1)'];
points2 = [set2.xArray(valid2)' set2.yArray(valid2)'];

dists = pdist2(points1,points2);
D12 = sum(min(dists,[],2));
D21 = sum(min(dists,[],1));
D = max(D12,D21);
end

