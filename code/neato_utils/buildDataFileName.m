function fname = buildDataFileName(source,tag,date,index,format)

if nargin < 5
	format = '.mat';
end
fname = ['data_' source '_' tag '_' date '_' index format];
end

