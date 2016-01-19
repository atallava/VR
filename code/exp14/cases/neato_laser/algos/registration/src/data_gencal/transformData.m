% for miscellaneous data transformations
fname = 'data_gencal_l_far_clear';
load(fname);

%%
nElements = length(dataset);
for i = 1:nElements
    dataset(i).X.sensorPose = dataset(i).X.sensorPose';
    dataset(i).X.perturbedPose = dataset(i).X.perturbedPose';
end

%%
save(fname,'dataset');