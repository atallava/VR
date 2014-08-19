function res = countToIndex(input)
% res = [choice pose pattern obs]
load pcd_file_data
nSims = 5;
if isscalar(input)
    [a,b,c,d] = ind2sub([nObs,nPatterns,nPoses,nSims],input);
    res = [d c b a];
else 
    res = sub2ind([nObs,nPatterns,nPoses,nSims],input(4),input(3),input(2),input(1));
end

end

