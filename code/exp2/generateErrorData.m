load processed_data1
%cell array of errors from measurements from each pose
error_pose = arrayfun(@(x) getError(ranges{x},x),1:6,'uni',0);
error_mat = vertcat(error_pose{:});
%get ids that correspond to different returns
partition = arrayfun(@(x) find(error_mat(:,1) == x),1:360,'uni',0);
errors = cellfun(@(x) squeeze(error_mat(x,2:end)), partition,'uni',0);
save('processed_data2.mat','errors','-append');
processed_data2_info = sprintf(['num_returns is the number of returns from the plane in space.\n' ...
    'errors is a cell array where errors{i} corresponds to data from return i\n' ...
    'error data is of form [true range, angle of incidence, range error]']);
save('processed_data2.mat','processed_data2_info','-append');
