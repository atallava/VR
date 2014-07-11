load density_data
nTriplets = size(triplets,1);

% Using fast_MVBW
pdf = precluster(triplets');
H = estimateBandwidth(pdf);
kde = constructKDE(pdf.Mu,pdf.w,H,pdf.Cov);

t1 = tic();
% takes about 2 hours
sampleProbValues = getProbAtLocation(kde.pdf,triplets);
fprintf('Computation took %fs.\n',toc(t1));