% generate sim data corresponding to model
cond = logical(exist('laserModel','var'));
assert(cond,('laserModel must exist in workspace.'));

fnameIn = '../src/data_gencal/data_gencal_train';
fnameOut = '../src/data_gencal/data_sim_train_des';

%%
clockLocal = tic();
realFile = load(fnameIn);
simFile.dataset = genSimData(laserModel,realFile.dataset);
fprintf('simDataForDebug:Computation time: %.2fs.\n',toc(clockLocal));

%%
save(fnameOut,'-struct','simFile');