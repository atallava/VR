start = rand(2,1)*5; start(3) = rand;
goal = rand(2,1)*5; goal(3) = rand;

ss = swingStraight(start,goal);
figure; hold on;
for t = linspace(0,ss.getTrajectoryDuration)
    p = ss.getPoseAtTime(t);
    quiver(p(1),p(2),0.1*cos(p(3)),0.1*sin(p(3)),'r','LineWidth',2);
end
plot(ss.bBox(:,1),ss.bBox(:,2),'g');
axis equal;