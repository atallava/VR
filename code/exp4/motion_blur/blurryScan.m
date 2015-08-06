load map_motion_blur
load sim_sep6_2
rsim.setMap(map);

%%
th = -deg2rad(3);
startPose = [0; 0; th];
finalPose = [0; 0; 0];
stages = 5;
rangesMotion = zeros(stages,360);
for i = 1:stages
	pose = [0; 0; th-i/stages*th];
	rangesMotion(i,:) = rsim.simulate(pose);
end

% assemble ranges
ranges = zeros(1,360);
chunk = 360/stages;
for i = 1:stages
	ids = (i-1)*chunk+1:i*chunk;
	ranges(ids) = rangesMotion(i,ids);
end

%%
map.plot();
hold on;
ri = rangeImage(struct('ranges',ranges));
plot(ri.xArray,ri.yArray,'r.','markersize',10);
for i = 1:stages
	pose = [0; 0; th-i/stages*th];
	if i == stages
		lc = [0 0 0];
	else
		lc = [0 0 0]+0.8;
	end
	hq(i) = quiver(pose(1),pose(2),0.4*cos(pose(3)),0.4*sin(pose(3)),'color',lc,'LineWidth',2); 
	adjust_quiver_arrowhead_size(hq(i),4);
end