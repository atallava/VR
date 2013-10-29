function range = getRangeToLine(j,line)
%returns expected range to line of a ray from origin at (j-1) degrees from the positive x-axis
m = tan(deg2rad(i-1));
x = -line(3)/(line(1)+line(2)*m); y = m*x;
range = norm([x y]);
end
