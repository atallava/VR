function m = directTrajMetric(fl1,fl2)
% fl1 and fl2 are filters

m = fl1.poseArray(1:2,:)-fl2.poseArray(1:2,:);
m = sqrt((sum(m.^2,1)));
m(isnan(m)) = [];
m = mean(m);

end

