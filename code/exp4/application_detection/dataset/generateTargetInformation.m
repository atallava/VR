% Convert target information to sensor frame.
load dataset_rangenorm

Ts2w = [ones(3,3) [1.87;1.97;0];...
    [0 0 0 1]];
laserDisp = [1.87 1.97];

nConf = length(confList);
targetLinesByConf = cell(1,nConf);
for i = 1:nConf
    conf = confList(i);
    lines = struct('p1',{},'p2',{});
    for j = 1:conf.nObjects
        if size(conf.objectList{j},1) == 2
            coords = conf.objectList{j};
            if toleranceCheck(norm(coords(1,:)-coords(2,:)),conf.lineLength1,1e-5)
                lines(end+1).p1 = [coords(1,:)-laserDisp;
                lines(end).p2 = coords(2,:)-laserDisp;                
            end
        end
    end
    targetLinesByConf{i} = lines;
end

%% plot as sanity check
lines = targetLinesByConf{1};
hf = figure; hold on;
for i = 1:length(lines);
    plot([lines(i).p1(1) lines(i).p2(1)],[lines(i).p1(2) lines(i).p2(2)]);
end
axis equal;
plot(0,0);
hold on;