function [ranges,bearings] = sampleReadingFromHistogram2(hCell,xc1,xc2,bearingGroups)
% hCell is size [G,1]. hCell{i} is [nXc1,nXc2].
% xc1 is array of length nXc1
% xc2 is array of length nXc2
% bearingGroups is size [G,g]

% why have the variable g? it will always be 2
[G,g] = size(bearingGroups,1);
ranges = zeros(1,G*g);
bearings = zeros(1,G*g);
for i = 1:G
    sample = sampleFromHistogram2(hCell{i},xc1,xc2);
    ranges(i) = sample(1); ranges(i+1) = sample(2);
    bearings(i) = bearingGroups(i,1); 
    bearings(i+1) = bearingGroups(i,2); 
end    
end