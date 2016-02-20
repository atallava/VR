% get serial object 
% use instrfind to figure out comName
comName = 'COM4';
lidar = setupLidar(comName);

%% get myHokuyo object
hk = myHokuyo(lidar);

%% plot ranges
hp = plot(0,0,'.'); 

axis equal;

% xlimDesired = [-1 1];
% ylimDesired = [-1 1];
% xlim(xlimDesired);
% ylim(ylimDesired);

xlabel('x');
ylabel('y');

lh = addlistener(hk,'laserEvent',@(s,e) updatePlot(s,e,hp));

%% clear hokuyo object
hk.shutdown();
clear hk;

%% clear serial object
fclose(lidar);
delete(lidar);
clear lidar;
