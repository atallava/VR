function outid = getOutliers(data, nclusters, f)
%naive function to detect outliers in data
%data: nxd
%nclusters: number of clusters
%f: fraction of max number of members to take as inlier threshold
%outid: array of ids from data which are classified as outliers

while true
    try
        [cid, ~] = kmeans(data, nclusters);
        break;
    catch
        continue
    end
end
cnum = arrayfun(@(x) length(find(cid == x)), 1:nclusters); %number of points in each cluster
thresh = max(cnum)*f;

cout = 1:nclusters;
cout = cout(cnum <= thresh); %misbeheaving clusters
outid = 1:size(data,1);
outid = outid(ismember(cid, cout));

end