% generate sim data corresponding to model
cond = logical(exist('laserModel','var'));
assert(cond,('laserModel must exist in workspace.'));

fnameIn = '../src/data/data_gencal_2_train';
fnameOut = '../src/data/data_sim_2_train_02';

%%
clockLocal = tic();
realFile = load(fnameIn);
simFile.dataset = genSimData(laserModel,realFile.dataset);
fprintf('simDataForDebug:Computation time: %.2fs.\n',toc(clockLocal));

%%
save(fnameOut,'-struct','simFile');