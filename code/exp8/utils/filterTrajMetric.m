function metric = filterTrajMetric(fl1,fl2)
% think of fl1 as registrationFilter, fl2 as motionFilter

p2Array = interpTrajectory(fl2.poseArray,[0 fl2.tArray],fl1.tArray);
metric = [];
for i = 1:length(fl1.tArray)
    x = fl1.poseArray(:,i)-p2Array(:,i); 
    W = eye(3);
    %W = fl1.SArray{i};
    term = sqrt(x'*(W\x));
    if isnan(term)
        continue;
    end
    metric = [metric term];
end
metric = mean(metric);

end