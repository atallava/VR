function snippet = genCodeVarsToStructFields(inputStruct)
%GENCODEVARSTOSTRUCTFIELDS 
% 
% snippet = GENCODEVARSTOSTRUCTFIELDS(inputStruct)
% 
% inputStruct - Structure with relevant fields.
% 
% snippet     - String.

if iscell(inputStruct)
	f = inputStruct;
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