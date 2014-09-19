function coords = getRotatedRect(pose,scale)
%GETROTATEDRECT Rotate a rectange template to pose.
% Originally intended to be used for built-in patch tool.
% Rectangle height is half the width
% 
% coords = GETROTATEDRECT(pose)
% 
% pose   - Length 3 vector.
% scale  - Optional argument to scale width by.
%          Default is 0.05.
% 
% coords - 4 x 2 array of coordinates

if nargin < 2
    scale = 0.05;
end
x = [-1 1 1 -1]*scale; 
y = [-1 -1 1 1]*scale*0.5;
coords = [x; y; ones(1,4)];

T = pose2D.poseToTransform(pose);
coords = T*coords;
coords(3,:) = []; coords = coords';

end

