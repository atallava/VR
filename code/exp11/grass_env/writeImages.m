load observations_static
pre = 'figs/static/';
xLimits = [-5 5];
yLimits = [-5 5];
for i = 1:150%size(rangeArray,1);
	ranges = rangeArray(i,:);
	ri = rangeImage(struct('ranges',ranges));
	hf = ri.plotXvsY();
	set(hf,'visible','off');
	xlim(xLimits); ylim(yLimits);
	xlabel('x (m)'); ylabel('y (m)');
	fname = [pre sprintf('%03d',i)];
	print(fname,'-dpng');
	close(hf);
end

%%
load observations_dynamic
pre = 'figs/dynamic/';
xLimits = [-5 5];
yLimits = [-5 5];
for i = 1:150%size(rangeArray,1);
	ranges = rangeArray(i,:);
	ri = rangeImage(struct('ranges',ranges));
	hf = ri.plotXvsY();
	set(hf,'visible','off');
	xlim(xLimits); ylim(yLimits);
	xlabel('x (m)'); ylabel('y (m)');
	fname = [pre sprintf('%03d',i)];
	print(fname,'-dpng');
	close(hf);
end

