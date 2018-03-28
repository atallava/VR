% application detection
addpath application_detection\

%% which sim
load sim_perf_log
simname = 'rsim';

%% 
nIter = length(perf);
for i = 1:nIter
    rs(i) = perf{i}.r;
    ps(i) = perf{i}.p;
    rr(i) = perfReal{i}.r;
    pr(i) = perfReal{i}.p;
end

% sim on sim
sCol = [1 0 0];
rCol = [0 0 1];
lVec = [-0.01 0.6];
pts = fnplt(cscvn([rs; ps])); 
for i = 1:size(pts,2)
	hp = plot(pts(1,1:i),pts(2,1:i),'color',sCol,'linewidth',3);
	hf = gcf;
	hold on; 
	hc = plot(pts(1,i),pts(2,i),'o','color',sCol,'linewidth',2);
	set(hf,'visible','off');
	axis equal; xlim(lVec); ylim(lVec);
	xlabel('recall'); ylabel('precision');
	legend(hc,{'simulated scans'});
	
	fname = sprintf('figs/icra_15/application_detection/%s_on_%s/fig_%2.2d.png',simname,simname,i);
	export_fig(fname,'-transparent',hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,'-transparent',hf);
	close(hf);
end

%% sim on real
sCol = [1 0 0];
rCol = [0 0 1];
lVec = [-0.01 0.6];
pts = fnplt(cscvn([rr; pr]));  
for i = 1:size(pts,2)
	hp = plot(pts(1,1:i),pts(2,1:i),'color',rCol,'linewidth',3);
	hf = gcf;
	hold on; 
	hc = plot(pts(1,i),pts(2,i),'o','color',rCol,'linewidth',2);
	set(hf,'visible','off');
	axis equal; xlim(lVec); ylim(lVec);
	xlabel('recall'); ylabel('precision');
	legend(hc,{'real scans'});
	
	fname = sprintf('figs/icra_15/application_detection/%s_on_%s/fig_%2.2d.png',simname,'real',i);
	export_fig(fname,'-transparent',hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,'-transparent',hf);
	close(hf);
end

%% sim on sim and real
sCol = [1 0 0];
rCol = [0 0 1];
lVec = [-0.01 0.6];
ptsSim = fnplt(cscvn([rs; ps]));  
ptsReal = fnplt(cscvn([rr; pr]));  
for i = 1:size(pts,2)
	plot(ptsSim(1,1:i),ptsSim(2,1:i),'color',sCol,'linewidth',3);
	hf = gcf;
	hold on; 
	plot(ptsReal(1,1:i),ptsReal(2,1:i),'color',rCol,'linewidth',3);
	hc1 = plot(ptsSim(1,i),ptsSim(2,i),'o','color',sCol,'linewidth',2);
	hc2 = plot(ptsReal(1,i),ptsReal(2,i),'o','color',rCol,'linewidth',2);
	set(hf,'visible','off');
	axis equal; xlim(lVec); ylim(lVec);
	xlabel('recall'); ylabel('precision');
	legend([hc1 hc2],{'simulated scans','real scans'});
	
	fname = sprintf('figs/icra_15/application_detection/%s_on_%s_and_%s/fig_%2.2d.png',simname,simname,'real',i);
	export_fig(fname,'-transparent',hf);
	fname = strrep(fname,'png','pdf');
	export_fig(fname,'-transparent',hf);
	close(hf);
end
