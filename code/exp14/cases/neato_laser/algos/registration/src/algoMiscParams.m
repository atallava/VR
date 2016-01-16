% registration algo has a bunch of params that we won't touch
numIter = 100;
skip = 3;

%% save
fname = 'data/algo_misc_params';
save(fname,'numIter','skip');
