% select bwX on holdout data
clc
fname = 'exp11_processed_data_sep6';
load(fname);

%% 
% CHECK PARAMETERS BEFORE ESTIMATING!
lzr = laserClass(struct());
bwZ = 1e-3;
n = 5;
lims1 = [0.005 0.05];
lims3 = deg2rad([0.5 15]);
[x1Array,x3Array] = meshgrid(linspace(lims1(1),lims1(2),n),linspace(lims3(1),lims3(2),n));
x1Array = x1Array(:);
% x2Array = x1Array(:);
x3Array = x3Array(:);

for i = 1:length(x1Array);
    bwXArray{i} = [x1Array(i) x3Array(i)];
end

%%
nHold = length(ZHold);
histDistance = @histDistanceKL;
t1 = tic();
bwXErr = zeros(1,length(bwXArray));
for i = 1:length(bwXArray)
    bwX = bwXArray{i};
    fprintf('bwX %d:', i); disp(bwX); fprintf('\n');
    bwXErr(i) = avgError(XTrain,ZTrain,XHold,ZHold,lzr,bwX,bwZ,histDistance);
end
fprintf('Computation took %.2fs\n',toc(t1));

[minErr,minId] = min(bwXErr);
bwXOpt = bwXArray{minId};

save('hyperparams_bwx','bwXArray','bwZ','bwXErr');