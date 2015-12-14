function genSimData(gtPre,tag,dateStr,indices)

inpBuildName.tag = tag;
inpBuildName.date = dateStr;
	
for i = 1:length(indices)
	inpBuildName.pre = gtPre;
	inpBuildName.source = 'gt';
	
	fprintf('Index: %d\n',i);
	inpBuildName.index = indices(i);
	fname = buildDataFileName(inpBuildName);
	
	inpNeato = load(fname);
	inpNeato.duration = max([inpNeato.tPose(end),inpNeato.tInputV(end), ...
		inpNeato.tEnc(end),inpNeato.tLzr(end)]);
	if ~isfield(inpNeato,'map')
		inpNeato.map = [];
	end
	inpNeato.plotting = 0;
	outNeato = offlineNeato(inpNeato);
	
	inpBuildName.pre = 'data/';
	inpBuildName.source = 'sim2';
	fname = buildDataFileName(inpBuildName);
	save(fname,'-struct','outNeato');
end
end