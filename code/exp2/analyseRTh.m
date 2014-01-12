i = 1; %first pixel index

if ~exist('errors','var')
    load('processed_data2.mat');
end

e = errors{i};
ftest = 0.1; %fraction of data to be used as test;
ntest = ceil(ftest*size(e,1));
rids = randperm(size(e,1));
testids = rids(1:ntest);
trainids = setdiff(1:size(e,1),testids);
etest = e(testids,:);
etrain = e(trainids,:);

%get polynomial fits to training data
[outspace, fm, fs] = arrayfun(@(x) analyseTheta(etrain,x,1), 6:-1:1, 'uni', 0);
outspace = cat(2,outspace{:});

bin_size = deg2rad(0.01);
etest_split = arrayfun(@(x) etest((etest(:,3) == x),:), 1:6, 'uni',0);
[test_bins, test_m, test_s, ~] = cellfun(@(data) getDistribParams(data,bin_size),etest_split,'uni',0); 
predicted_m = arrayfun(@(x) polyval(fm{x}, test_bins{x}), 1:6, 'uni', 0);
predicted_s = arrayfun(@(x) polyval(fs{x}, test_bins{x}), 1:6, 'uni', 0);
%get error in mean and variance prediction on test data
error_m = arrayfun(@(x) predicted_m{x}-test_m{x}, 1:6, 'uni', 0);
error_s = arrayfun(@(x) predicted_s{x}-test_s{x}, 1:6, 'uni', 0);
avg_errm = cellfun(@(data) mean(data), error_m)
avg_errs = cellfun(@(data) mean(data), error_s)

%{
%visualize outliers
figure;
scatter(e(:,2),e(:,1),5,'b');
hold on;
scatter(outspace(1,:),outspace(2,:),50,'r');
%}