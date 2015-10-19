function indices = findDataIndices(inputStruct,dirName)
% what if you know all fields, but not how many indices there are?

indices = [];
inputStruct.pre = '';
inputStruct.index = 1; 
fname = buildDataFileName(inputStruct);
fname(end-5:end) = []; % snip off dummy index and format
fStruct = dir(dirName);

for i = 1:length(fStruct)
	name_i = fStruct(i).name;
	if strcmp(name_i,'.') || strcmp(name_i,'..')
		continue;
	end
	posn = strfind(name_i,fname);
	% no match
	if isempty(posn)
		continue;
	end
	posn1 = length(fname)+posn+1;
	posn2 = length(name_i)-4;
	% probably no index
	if posn2 < posn1
		continue;
	end
	% extract index
	indices = [indices str2double(name_i(posn1:posn2))];
end

end