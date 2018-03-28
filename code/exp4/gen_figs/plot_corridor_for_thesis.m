% plot corridor as example of scenes which can be constructed

%% load
load('../data/nsh3_corridor.mat','map');

%% viz
% here is a drawback of matlab objects. hard to play with plot properties
% coded in class
hfig = figure; hold on; axis equal;
lineWidth = 4;
for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end

xlim([-4 10]); ylim([-3.5 2.5]);
xlabel('x (m)'); ylabel('y (m)');
fontSize = 15;
set(gca, 'fontSize', fontSize);