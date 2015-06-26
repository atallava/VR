load dataset_rangenorm
for i = 1:length(confList)
	hf = confList(i).plot();
	set(hf,'visible','off');
	print('-dpng','-r72',sprintf('figs/confs/configuration_%d.png',i));
	close(hf);
end