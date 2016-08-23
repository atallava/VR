cload ../data/npreg_didnt_2

%% environment
% dynamic objects in a shade of grey
hfig = dynamicMap.plot();
% axes handle
haxes = get(hfig,'children');
% plot handles
hplots = get(haxes,'children');
colorDynamicObjects = [1 1 1]*0.7;
desiredLinewidth = 7;
for i = 1:length(hplots)
    set(hplots(i),'color',colorDynamicObjects,'linewidth',desiredLinewidth);
end

% map in black
figure(hfig);
hold on;
% get walls
walls = map.objects();
colorWalls = [1 1 1]*0;
for i = 1:length(walls)
    lines = walls(i).lines;
    plot(lines(:,1),lines(:,2),'color',colorWalls,'linewidth',desiredLinewidth);
end

% padding
padding = [-0.5 0.5];
desiredXlim = [-0.2 5.2];
desiredYlim = [-0.5 3];
xlim(desiredXlim);
ylim(desiredYlim);

% axes font size
fs = 15;
set(gca,'FontSize',fs);

box on;
xlabel('x (m)','fontsize',fs); 
ylabel('y (m)','fontsize',fs);

%% poses
scatterPointArea = 60;
quiverScale = 0.5;

% true pose
colorTruePose = [1 0 0];
scatter(pose(1),pose(2,:),scatterPointArea,'filled','MarkerFaceColor',colorTruePose);
quiver(pose(1),pose(2),quiverScale*cos(pose(3)),quiverScale*sin(pose(3)),...
    'Color',colorTruePose,'LineWidth',2,'autoscale','off');

% particle poses
colorParticles = [0 1 0]*0.7;
poses = [particles.pose];
scatter(poses(1,:),poses(2,:),scatterPointArea,'filled','MarkerFaceColor',colorParticles);

% quiver npreg particle
npregVoteId = 1;
quiver(poses(1,npregVoteId),pose(2,npregVoteId),...
    quiverScale*cos(poses(3,npregVoteId)),quiverScale*sin(poses(3,npregVoteId)),...
    'Color',colorParticles,'LineWidth',2,'autoscale','off');

% quiver thrun particle
% thrunVoteId = 13;
% quiver(poses(1,thrunVoteId),poses(2,thrunVoteId),...
%     quiverScale*cos(poses(3,thrunVoteId)),quiverScale*sin(poses(3,thrunVoteId)),...
%     'Color',colorParticles,'LineWidth',2,'autoscale','off');
