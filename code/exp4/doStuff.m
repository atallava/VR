%% get parameters for pdfs on training data

clear all; clc;
load processed_data

nPoses = length(poses);
frac = 0.8;
trainIds = randperm(nPoses,floor(0.8*nPoses));
[pdf_params, p_zero] = getMLEEstimates('normal',trainIds);

%% predict parameters at test poses using GPs
clc;

testIds = setdiff(1:nPoses,trainIds);
nParams = size(pdf_params,1);
test_pdf_params = zeros(nParams,length(testIds));
nRays = length(pdf_params);

meanfunc = []; hyp.mean = [];
covfunc = @covSEiso; 
likfunc = @likGauss; 
for rayId = 1
    %for i = 1:nParams
        hyp.cov = [0;0]; hyp.lik = log(0.1);
        hyp = minimize(hyp,@gp,-100,@infExact,meanfunc,covfunc,likfunc,poses(1,trainIds),pdf_params{rayId}(1,:));
        %[mu,~] = gp(hyp,@infExact,meanfunc,covfunc,likfunc,poses(:,testIds));
        %test_pdf_params(i,:) = mu;
    %end
end

