function [drift,range_data] = getData(rob)
%rob's laser must be on
%...should be a way to check that via code
%report back total drift in position and velocity
%t1 is the time to pause between consecutive range measurements of the same scene
  t1 = 0.15;
drift = zeros(3,1);
range_data = zeros(360,100,360);
for i = 1:360
  while j = 1:100
    range_data(i,j,:) = rob.laser.data.ranges;
    pause(t1);
  end
  [ds,dth] = degTurn(rob);
  drift(3) = drift(3)+dth;
  drift(1:2) = drift(1:2) + ds*[cos(drift(3)) sin(drift(3))];
end
end