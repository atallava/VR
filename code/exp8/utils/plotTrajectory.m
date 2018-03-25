function hf = plotTrajectory(poseArray,map,hf)
if nargin < 3
    hf = map.plot;
end

figure(hf);
hold on;
plot(poseArray(1,:),poseArray(2,:),'r--');
hold off;
axis equal;
end