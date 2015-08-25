sample_index = 1;
fname = ['z_' num2str(sample_index)];
load(fname)
sensor = laserClass(struct());

%%
J = 1e5;
[h,xc] = ranges2Histogram(z,sensor);
theta = estimateOrthogonalCosine(z,J);
hPred = histogramFromOrthogonalCosine(theta,xc);

%%
vizHists(h,hPred,xc);
