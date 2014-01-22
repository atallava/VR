% required in workspace: rob object of class neato, rstate object of class
% robState, rob's laser must be turned on

filename = 'data_XXJan.mat';
num_runs = 20;
num_range_data = 500;
for i = 1:num_runs
     % collect laser data
    ranges = zeros(360,num_range_data);
    for j = 1:num_range_data
        ranges(:,j) = rob.laser.data.ranges;
        pause(0.3);
    end
    
    % write to file
    varname1 = strcat('readings',int2str(i));
    varname2 = strcat('pose',int2str(i));
    S.(varname1) = ranges;
    S.(varname2) = rstate.pose;
    save(filename,'-strcat','S');
    
    % move the robot ahead
    t1 = tic;
    while toc(t1) < 2.5
        rob.sendVelocity(0.02,0.02);
        pause(0.001);
    end
    rob.sendVelocity(0,0);
    rstate.reset(rstate.pose);    
end