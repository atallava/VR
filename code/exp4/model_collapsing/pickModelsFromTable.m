function modelIds = pickModelsFromTable(table)
%PICKMODELSFROMTABLE Given cover table, return selected models.
% Implements greedy set cover. Additionally, at each iteration there is a
% check to avoid adding superflous sets.
% 
% modelIds = PICKMODELSFROMTABLE(table)
% 
% table    - Square array of 0s and 1s.
% 
% modelIds - Array of selected model ids.

n = size(table,1);
currentCover = 0;
modelIds = [];
labels = 1:n;
setList = coverTableToSets(table);
iter = 1;
while ~all(currentCover)
    nCovers = sum(table,1);
    maxNCover = max(nCovers);
    candidates = find(nCovers == maxNCover);
    pick = candidates(randperm(length(candidates),1));
    if ~isempty(setdiff(setList{labels(pick)},find(currentCover)))
        modelIds(end+1) = labels(pick);
        currentCover = currentCover+table(:,pick);
    end
    
    fprintf('iter: %d...\n',iter);
    fprintf('maxNCover: %d\n',maxNCover);
    fprintf('pick: %d\n',labels(pick));
    fprintf('currentCoverLength: %d\n',sum(currentCover > 0));
    fprintf('nModels: %d\n',length(modelIds));
    fprintf('\n');    
    
    table(:,pick) = [];
    labels(pick) = [];
    iter = iter+1;
end

end