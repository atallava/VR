function setList = coverTableToSets(table)
%COVERTABLETOSETS Convert cover table to sets.
% 
% setList = COVERTABLETOSETS(table)
% 
% table   - Square array of 0s and 1s. 
% 
% setList - Cell array of sets corresponding to each column,

n = size(table,1);
setList = cell(1,n);
for i = 1:n
    setList{i} = find(table(:,i));
end

end

