function readings = getData(rob,p)
% return 100 readings collected from pixel p
readings = zeros(length(p),100);
for i = 1:100;
    readings(:,i) = rob.laser.data.ranges(p);
    pause(0.3);
end
end