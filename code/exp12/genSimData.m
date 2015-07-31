function genSimData(tag,dateStr,indices)

for i = 1:length(indices)
	index = indices(i);
	fname = buildDataFileName('gt',tag,dateStr,index);
	fname = ['data/' fname];
	inputStruct = load(fname);
	inputStruct.duration = inputStruct.tInputV(end)+1;
	inputStruct.plotting = 1;
	outputStruct = offlineNeato(inputStruct);
	fname = buildDataFileName('sim',tag,dateStr,index);
	fname = ['data/' fname];
	save(fname,'-struct','outputStruct');
end



end

