function [avg_dist,best_consensus_set,best_line] = lineFitRANSAC(pts, num_iter, min_pts, t)
%pts is an nx2 array, where n is the number of points

%num_iter: number of iterations to be performed
%min_pts: minimum pts needed to fit model
%t: threshold for deciding if point belongs to model

best_line = zeros(3,1);
best_score = 0;
best_consensus_set = [];
for i = 1:num_iter
    %get minimum points at random  
    sample_ids = randperm(size(pts,1), min_pts);
    sample_pts = pts(sample_ids,:);
    %get line
    [~, line] = getLine(sample_pts);
    %get consensus set
    %consensus_set = sample_ids;
    %rest_ids = 1:length(pts); rest_ids(sample_ids) = [];
    dists = distToLine(pts, line);
    consensus_set = find(dists < t);
    %check if model is good    
    if length(consensus_set) > best_score
    %score is number of points in consensus_set
      best_score = length(consensus_set);
      best_consensus_set = consensus_set;
      best_line = line;
    end
end

if ~isempty(best_consensus_set)
    %get average distance of best_consensus_set to best_line
    dists = distToLine(pts(best_consensus_set,:),best_line);
    avg_dist = mean(dists);
else
    avg_dist = -1; %indicates that no consensus_set has been found
end

end
