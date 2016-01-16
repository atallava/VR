% for miscellaneous data transformations
fname = 'data_gencal_2';
load(fname);

%%
nElements = length(dataset);
for i = 1:nElements
    ranges = dataset(i).Y;
    Y.ranges = ranges;
    dataset(i).Y = Y;
end

%%
save(fname,'dataset');