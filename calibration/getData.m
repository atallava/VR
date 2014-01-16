function readings = getData(rob,num_readings,p)
% return num_readings collected from pixel p
readings = zeros(length(p),num_readings);
for i = 1:num_readings;
    readings(:,i) = rob.laser.data.ranges(p);
    pause(0.3);
end
end