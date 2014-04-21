function hf = vizRealRanges(localizer,obsArray,poses,poseId)
hf = localizer.drawLines();
xl0 = xlim;
yl0 = ylim;
xlabel('x'); ylabel('y');
hold on;
xRob = poses(1,poseId); yRob = poses(2,poseId); thRob = poses(3,poseId);
quiver(xRob,yRob,0.2*cos(thRob),0.2*sin(thRob),'k','LineWidth',2);

obsId = randperm(50,1);
rangesReal = rangesFromObsArray(obsArray,poseId,obsId);
xReal = xRob+ rangesReal.*cos(thRob+deg2rad(0:359));
yReal = yRob+ rangesReal.*sin(thRob+deg2rad(0:359));
plot(xReal,yReal,'go');
title(sprintf('pose %d: (%f,%f,%f)',poseId,xRob,yRob,thRob));
xl0 = xl0+[-1 1];
yl0 = yl0+[-1 1];
xlim(xl0);
ylim(yl0);
end

