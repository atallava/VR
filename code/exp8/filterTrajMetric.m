function metric = filterTrajMetric(fl1,fl2)
% think of fl1 as registrationFilter, fl2 as motionFilter

p2Array = interpTrajectory(fl2.poseArray,fl2.tArray,fl1.tArray);
metric = 0;
for i = 1:length(fl1.tArray)
    x = fl1.poseArray(:,i)-p2Array(:,i);
    W = eye(3); 
    %W = fl1.SArray{i};
    metric = metric+x'*(W\x);
end
metric = metric/length(fl1.tArray);

end