% write range figures
% paths may be broken

runId = 7;
load('../data/b100_padded_corridor','map');

localizer = lineMapLocalizer(map.objects);
vizer = vizRangesOnMap(struct('map',map,'laser',robotModel.laser));

choices = {'real','sim','baseline'};


t1 = tic();
for choice = choices
    choice = choice{1};
    srcName = [choice '_sensor_data'];
    load(srcName);
    prefix = ['figs/trajectory_snapshots_robot/' choice];
    
    scans = sensorData(runId).scanArray;
    for i = 1:length(scans)
        ranges = scans{i};
        ri = rangeImage(struct('ranges',ranges));
        hf = ri.plotXvsY([],5);
        set(hf,'visible','off');
        xlim([-4 4]);
        ylim([-4 4]);
        id = num2str(i);
        id = [repmat('0',1,3-numel(id)) id];
        fname = [prefix '/' id];
        print(hf,fname,'-dpng');
        close(hf);
    end
end
fprintf('Computation took %.2fs.\n',toc(t1));