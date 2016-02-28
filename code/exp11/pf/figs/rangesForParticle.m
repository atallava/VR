load ../data/npreg_didnt_2

%% environment
% dynamic objects in a shade of grey
hfig1 = dynamicMap.plot();
% axes handle
haxes = get(hfig1,'children');
% plot handles
hplots = get(haxes,'children');
colorDynamicObjects = [1 1 1]*0.7;
desiredLinewidth = 7;
for i = 1:length(hplots)
    set(hplots(i),'color',colorDynamicObjects,'linewidth',desiredLinewidth);
end

% map in black
figure(hfig1);
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

% make a copy
% hfig2 = copyobj(hfig1,0);

%% observed ranges
B = length(obsModelStruct.ranges);
id = 1;
pose = obsModelStruct.poses(:,id);
rangesObserved = obsModelStruct.ranges;
bearingsObserved = obsModelStruct.bearings;
ri1 = rangeImage(struct('ranges',rangesObserved,'bearings',obsModelStruct.bearings));

% figure 1
figure(hfig1);

% observed ranges
scatterPointArea = 60;
quiverScale = 0.4;
colorRanges = [1 0 0];
pts = [flipVecToRow(ri1.xArray); ...
    flipVecToRow(ri1.yArray)];
pts = pose2D.transformPoints(pts,pose);
scatter(pts(1,:),pts(2,:),scatterPointArea,'o','MarkerFaceColor',colorRanges,'MarkerEdgeColor',colorRanges);

% nominal ranges
rangesNominalParticle = obsModelStruct.rangesNominal((id-1)*B+1:id*B);
ri2 = rangeImage(struct('ranges',rangesNominalParticle,'bearings',obsModelStruct.bearings));
pts = [flipVecToRow(ri2.xArray); ...
    flipVecToRow(ri2.yArray)];
pts = pose2D.transformPoints(pts,pose);
scatter(pts(1,:),pts(2,:),scatterPointArea,'x','MarkerEdgeColor',colorRanges,'LineWidth',3);

colorPose = [0 0.7 0];
% pose
scatter(pose(1),pose(2),scatterPointArea,'filled','MarkerFaceColor',colorPose);
quiver(pose(1),pose(2),quiverScale*cos(pose(3)),quiverScale*sin(pose(3)),...
    'Color',colorPose,'LineWidth',2,'autoscale','off');

% draw a dotted range line for bearing of concern
plot([pose(1) pts(1,10)],[pose(2) pts(2,10)],'--','color',[1 0 0],'linewidth',1.5);

