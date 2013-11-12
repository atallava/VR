function box = getBox(box,dpose)
%get a box around points of interest, 4x2 array
%box is a 4x2 rectangle containing points of interest in starting orientation of
%bot. corners specified counter-clockwise, starting from bottom left
%dpose is [dx dy dtheta], estimated errors in pose

%dilate box to account for dx,dy
box = box + [-dpose(1) -dpose(2); dpose(1) -dpose(2); dpose(1) dpose(2); -dpose(1) dpose(2)];

%distance from origin to corner points
r = pdist2(box,[0 0]);
%angles from origin to box corner points
A3 = atan(box(3,2)/box(3,1)); A4 = atan(box(4,2)/box(4,1));
A2 = A3; A1 = A4;
%down-right-up-left shifts to account for dpose(3)
shift = [-r(3)*sin(dpose(3)/2)*cos(A3+dpose(3)/2) r(2)*sin(dpose(3)/2)*sin(A2-dpose(3)/2) r(3)*sin(dpose(3)/2)*cos(A3+dpose(3)/2) -r(4)*sin(dpose(3)/2)*sin(A4+dpose(3)/2)];
box = box + [shift(4) shift(1); shift(2) shift(1); shift(2) shift(3); shift(4) shift(3)];
end

