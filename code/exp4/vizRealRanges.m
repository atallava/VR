function hf = vizRealRanges(localizer,ranges,pose,bearings)
% vizRealRanges draw real ranges on a map

if nargin < 4
    bearings = deg2rad(0:359);
end

hf = localizer.drawLines();
xl0 = xlim;
yl0 = ylim;
xlabel('x'); ylabel('y');
hold on;
quiver(pose(1),pose(2),0.2*cos(pose(3)),0.2*sin(pose(3)),'k','LineWidth',2);

x = pose(1)+ranges.*cos(pose(3)+bearings);
y = pose(2)+ranges.*sin(pose(3)+bearings);
plot(x,y,'go');
title(sprintf('pose: (%f,%f,%f)',pose(1),pose(2),pose(3)));
xl0 = xl0+[-1 1];
yl0 = yl0+[-1 1];
xlim(xl0);
ylim(yl0);
end