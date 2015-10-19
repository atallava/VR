function snippet = genCodeVarsToStructFields(in)
if iscell(in)
	f = in;
else
	f = fields(inputStruct);
end
snippet = [];
for i = 1:length(f)
	line = ['inputStruct.' f{i} ' = ' f{i} ';'];
	line = sprintf('%s\n',line);
	fprintf('%s',line);
	snippet = [snippet line];
end
end