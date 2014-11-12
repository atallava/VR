tp = trajPlanner(struct('file','trajectory_table.mat'));

%%
startPoses = repmat([0.5 0.5 pi/2]',1,30);
finalXY = [repmat([1.5; 2.2],1,10) ...
	repmat([2; 2],1,10) ...
	repmat([2; 1],1,10)];
nPoses = 30;
finalPoses = zeros(3,nPoses);
thLim = [0 pi/2];

for i = 1:nPoses
	fprintf('Generating trajectory %d.\n',i);
	th = rand()*(thLim(2)-thLim(1))+thLim(1);
	finalPoses(:,i) = [finalXY(:,i); th];
	csp(i) = tp.planPath(startPoses(:,i),finalPoses(:,i));
end

%%
hf = figure; hold all;
for i = 1:length(csp)
	plot(csp(i).poseArray(1,:),csp(i).poseArray(2,:))
end
axis equal;
grid on;