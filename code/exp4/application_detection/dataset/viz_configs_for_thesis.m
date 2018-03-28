% plot some sample configurations

%% load 
load dataset_rangenorm.mat

%% pick conf
nConfs = length(confList);
confId = randsample(nConfs,1);
fprintf('conf id: %d\n', confId);

map = confList(confId).map;

%% viz
hfig = figure; hold on; axis equal;
lineWidth = 4;
for obj = map.objects
    plot(obj.line_coords(:,1), obj.line_coords(:,2),...
        'Color', 'b', 'linewidth', lineWidth);
end

xlabel('x (m)'); ylabel('y (m)');
fontSize = 15;
set(gca, 'fontSize', fontSize);