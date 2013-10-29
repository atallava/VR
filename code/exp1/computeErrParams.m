load('processed_data.mat','err');
[err_std, err_mean] = deal(zeros(1,size(err,1)));
for i = 1:size(err,1)
  err_mean(i) = mean(err{i,2});
  err_std(i) = std(err{i,2});
end