load sim_reg_filters
load motion_filter_object

score = [];
for i = 1:length(rflArray)
    score = [score filterTrajMetric(rflArray(i),mfl)];
end
mean(score)