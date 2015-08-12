% select bwX and bwY on holdout data
clc;
fname = 'exp11_processed_data_sep6';
load(fname);

%% get bw errors on hold out data
% rbf kernel
[bwXArray,bwZArray] = meshgrid(linspace(0.001,0.02,5),linspace(0.001,0.02,5));
bwXArray = bwXArray(:); bwZArray = bwZArray(:);
% histDistance = @histDistanceEuclidean;
histDistance = @histDistanceKL;
lzr = robotModel.laser;
errFn = @(bwX,bwZ) avgError(XTrain,ZTrain,XHold,ZHold,lzr,bwX,bwZ,histDistance);

t1 = tic();
bwErr = getBwErr(bwXArray,bwZArray,errFn);
fprintf('Computation took %.2fs\n',toc(t1));

[minErr,minId] = min(bwErr);
bwXOpt = bwXArray(minId);
bwZOpt = bwZArray(minId);

save('hyperparams_bwx_bwz','bwXArray','bwZArray','bwErr');