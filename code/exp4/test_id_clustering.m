load test_id_clustering_data
nOuts = length(outIds);

%% test: given start, find end
first = randperm(nOuts,1);

[~,next] = circArray.circNbrs(first,nOuts);
while true
    if next == first
        [last,~] = circArray.circNbrs(first,nOuts);
        break;
    end
    if circArray.circDiff(outIds(first),outIds(next),360) ~= circArray.circDiff(first,next,nOuts)
        [last,~] = circArray.circNbrs(next,nOuts);
        break
    end
    [~,next] = circArray.circNbrs(next,nOuts);
end
fprintf('first: %d, last: %d\n',first,last);
fprintf('outIds(first): %d, outIds(last): %d\n',outIds(first),outIds(last));

%% Form outlier clusters
count = 1;
outClusters = struct('first',{},'last',{});
outClusters(count).first = 1;
next = 1;

while next <= nOuts
    if circArray.circDiff(outIds(outClusters(count).first),outIds(next),360) ~= circArray.circDiff(outClusters(count).first,next,nOuts)
        [last,~] = circArray.circNbrs(next,nOuts);
        outClusters(count).last = last;
        count = count+1;
        outClusters(count).first = next;
    end
    next = next+1;
end
outClusters(count).last = nOuts;

% connect circle if needed
if circArray.circDiff(outIds(outClusters(end).last),outIds(outClusters(1).first),360) == 1
    outClusters(1).first = outClusters(end).first;
    outClusters(end) = [];
end

minOutClusterLength = 3;
% weed out short clusters
throw = [];
for i = 1:length(outClusters)
    if circArray.circDiff(outClusters(i).first,outClusters(i).last,nOuts) < minOutClusterLength
        throw = [throw i];
    end
end
outClusters(throw) = [];

for i = 1:length(outClusters)
    outClusters(i).first = outIds(outClusters(i).first);
    outClusters(i).last = outIds(outClusters(i).last);
end
%% Plot stuff
vec = nan(1,360); vec(outIds) = 1; 
plot(1:360,vec,'r+'); hold on;
for i = 1:length(outClusters)
    plot([outClusters(i).first outClusters(i).last],[1 1],'b','LineWidth',2)
end

%% Form inlier clusters
maxInClusterLength = 10;
minInClusterLength = floor(maxInClusterLength/2);
inClusters = struct('first',{},'last',{});
for i = 1:length(outClusters)
    [left,~] = circArray.circNbrs(i,length(outClusters));
    [~,first] = circArray.circNbrs(outClusters(left).last,360);
    [last,~] = circArray.circNbrs(outClusters(i).first,360);
    if first > last
        dummyLast = circArray.circDiff(first,last,360);
        vec1 = 0:maxInClusterLength:dummyLast;
        r = dummyLast-vec1(end)+1;
        if r > 0 && r < minInClusterLength
            vec1(end) = dummyLast-minInClusterLength+1;
        end
        vec2 = [vec1(2:end)-1 dummyLast];
        vec1 = vec1+first; vec1(vec1>360) = vec1(vec1>360)-360;
        vec2 = vec2+first; vec2(vec2>360) = vec2(vec2>360)-360;
    else
        vec1 = first:maxInClusterLength:last;
        r = last-vec1(end)+1;
        if r > 0 && r < minInClusterLength
            vec1(end) = last-minInClusterLength+1;
        end
        vec2 = [vec1(2:end)-1 last];
    end
        temp = struct('first',num2cell(vec1),'last',num2cell(vec2));
        inClusters = [inClusters temp];
end