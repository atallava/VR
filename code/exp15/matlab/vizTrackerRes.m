function hf = vizTrackerRes(desiredPathFname,followedPathFname)
% load desired path
desiredPathStt = loadDesiredPath(desiredPathFname);

% load followed path
followedPathStt = loadFollowedPath(followedPathFname);

% plot
hf = figure;
plot([desiredPathStt.x],[desiredPathStt.y],'b');
axis equal; 
hold on;
plot([followedPathStt.x],[followedPathStt.y],'r');
xlabel('x');
ylabel('y');
legend('desired path','followed path');
end