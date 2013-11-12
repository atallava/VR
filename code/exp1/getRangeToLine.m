function range = getRangeToLine(theta,line)
%returns expected range to line of a ray from origin at theta (rad) from the positive x-axis
m = tan(theta);
x = -line(3)/(line(1)+line(2)*m); y = m*x;
range = norm([x y]);
end
