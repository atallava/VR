tp = trajPlanner(struct('file','trajectory_table.mat'));

%%
startPose = [0 0 pi/2];
finalXY = [2 2]';
nPoses = 30;
finalPoses = zeros(3,nPoses);
thLim = [0 pi/2];

for i = 1:nPoses
	fprintf('Generating trajectory %d.\n',i);
	th = rand()*(thLim(2)-thLim(1))+thLim(1);
	finalPoses(:,i) = [finalXY; th];
	csp(i) = tp.planPath(startPose,finalPoses(:,i));
end

%%
hf = figure; hold all;
for i = 1:length(csp)
	plot(csp(i).poseArray(1,:),csp(i).poseArray(2,:))
end
axis equal;
grid on;