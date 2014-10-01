clearAll
choices = {'real','sim','baseline'};

t = cell(1,length(choices));
d = cell(1,length(choices));

for i = 1:length(choices)
    [t{i},d{i}] = statsOverRflParams(choices{i});
end