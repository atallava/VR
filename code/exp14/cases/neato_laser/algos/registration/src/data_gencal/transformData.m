% for miscellaneous data transformations
fname = 'data_gencal';
load(fname);

%%
nData = length(X);
dataset = struct('X',{},'Y',{});
for i = 1:nData
    dataset(i).X = X(i);
    dataset(i).Y = Y(i);
end

%%
save(fname,'dataset');