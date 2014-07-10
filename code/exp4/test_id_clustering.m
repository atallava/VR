load test_id_clustering_data
nOuts = length(outIds);

%% test: given start, find end
first = randperm(nOuts,1);

[~,next] = circNbrs(first,nOuts);
while true
    if next == first
        [last,~] = circNbrs(first,nOuts);
        break;
    end
    if circDiff(outIds(first),outIds(next),360) ~= circDiff(first,next,nOuts)
        [last,~] = circNbrs(next,nOuts);
        break
    end
    [~,next] = circNbrs(next,nOuts);
end
fprintf('first: %d, last: %d\n',first,last);
fprintf('outIds(first): %d, outIds(last): %d\n',outIds(first),outIds(last));

%% From clusters
count = 1;
outClusters = struct('first',{},'last',{});
outClusters(count).first = 1;
next = 1;

while next <= nOuts
    if circDiff(outIds(outClusters(count).first),outIds(next),360) ~= circDiff(outClusters(count).first,next,nOuts)
        [last,~] = circNbrs(next,nOuts);
        outClusters(count).last = last;
        count = count+1;
        outClusters(count).first = next;
    end
    next = next+1;
end
outClusters(count).last = nOuts;


% connect circle if needed
if circDiff(outIds(outClusters(end).last),outIds(outClusters(1).first),360) == 1
    outClusters(1).first = outClusters(end).first;
    outClusters(end) = [];
end

minClusterLen = 5;
% weed out short clusters
throw = [];
for i = 1:length(outClusters)
    if circDiff(outClusters(i).first,outClusters(i).last,nOuts) < minClusterLen
        throw = [throw i];
    end
end
outClusters(throw) = [];

%% Plot shit
vec = nan(1,360); vec(outIds) = 1; 
plot(1:360,vec,'r+'); hold on;
for i = 1:length(outClusters)
    plot([outIds(outClusters(i).first) outIds(outClusters(i).last)],[1 1],'b')
end

