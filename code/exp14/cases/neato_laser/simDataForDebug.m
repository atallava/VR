% generate sim data corresponding to a model for debugging

fnameIn = 'algos/detection/data_real_train';
fnameOut = 'algos/detection/data_sim_train';

%%
clockLocal = tic();
dataReal = load(fnameIn);
% assuming laserModel exists in workspace
dataSim = genSimData(laserModel,dataReal);
fprintf('simDataForDebug:Computation time: %.2fs.\n',toc(clockLocal));

%% 
save(fnameOut,'-struct','dataSim');