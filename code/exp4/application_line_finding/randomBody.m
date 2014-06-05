function body = randomBody(choice)

ranges0 = [5 7]*0.01;
ranges1 = [35 60]*0.01;

if choice
    body = generateBody(ranges1);
else
    body = generateBody(ranges0);
end
end

function body = generateBody(ranges)
side1 = rand*(ranges(2)-ranges(1))+ranges(1);
side2 = rand*(ranges(2)-ranges(1))+ranges(1);
th = rand*pi;
body = lineObject;
points =  [-side1 -side2; side1 -side2; side1 side2; -side1 side2; -side1 -side2]*0.5;
points = [cos(th) sin(th); ...
         -sin(th) cos(th)]*points';
body.lines = points';
end

