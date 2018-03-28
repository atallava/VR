% scans
load processed_data_sep6
load sim_sep6_2
load roomLineMap

%%
numScans = 20;
pid = 20;
pose = poses(:,pid);
xl = [-0.3 3.95];
yl = [-0.52 2.4];

%% real scans
for i = 1:numScans
	ranges = rangesFromObsArray(obsArray,pid,i);
	ri = rangeImage(struct('ranges',ranges));
	hf = ri.plotXvsY(pose);
	set(hf,'visible','off');
	xlim(xl); ylim(yl);
	fname = sprintf('figs/icra_15/real_scans_box_world/scan_%2.2d.png',i);
	export_fig(fname,hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,hf);
	close(hf);
end

%% naive sim scans
for i = 1:numScans
	ranges = map.raycastNoisy(pose,rsim.laser.maxRange,rsim.laser.bearings);
	ri = rangeImage(struct('ranges',ranges));
	hf = ri.plotXvsY(pose);
	set(hf,'visible','off');
	xlim(xl); ylim(yl);
	fname = sprintf('figs/icra_15/naive_sim_scans_box_world/scan_%2.2d.png',i);
	export_fig(fname,'-transparent',hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,'-transparent',hf);
	close(hf);
end

%% rsim scans
rsim.setMap(map);
for i = 1:numScans
	ranges = rsim.simulate(pose);
	ri = rangeImage(struct('ranges',ranges));
	hf = ri.plotXvsY(pose);
	set(hf,'visible','off');
	xlim(xl); ylim(yl);
	fname = sprintf('figs/icra_15/rsim_scans_box_world/scan_%2.2d.png',i);
	export_fig(fname,'-transparent',hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,'-transparent',hf);
	close(hf);
end


