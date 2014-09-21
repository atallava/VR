load dataset
for i = 1:length(confList)
	hf = confList(i).plot();
	set(hf,'visible','off');
	print('-dpng','-r72',sprintf('images/configuration_%d.png',i));
	close(hf);
end