% generate sim data corresponding to model
cond = logical(exist('laserModel','var'));
assert(cond,('laserModel must exist in workspace.'));

fnameIn = 'algos/registration/data_gencal/data_gencal_train';
fnameOut = 'algos/registration/data_gencal/data_sim_train';

%%
clockLocal = tic();
dataReal = load(fnameIn);
% assuming laserModel exists in workspace
dataSim = genSimData(laserModel,dataReal);
fprintf('simDataForDebug:Computation time: %.2fs.\n',toc(clockLocal));

%%
save(fnameOut,'-struct','dataSim');