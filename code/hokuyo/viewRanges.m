SetupLidar;

%%
hk = myHokuyo(lidar);

%%
hp = plot(0,0,'.'); axis equal;
lh = addlistener(hk,'laserEvent',@(s,e) updatePlot(s,e,hp));
