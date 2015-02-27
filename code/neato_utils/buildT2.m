function T = buildT2(th,v)
%BUILDT2 Form 2D transformation matrix.
% 
% T = BUILDT2(th,v)
% 
% th - Angle in radian.
% v  - 2x1 array.
% 
% T  - Transformation matrix.

R = [cos(th) -sin(th); ...
	sin(th) cos(th)];
T(1:2,1:2) = R;
T(1:2,3) = v;
end

