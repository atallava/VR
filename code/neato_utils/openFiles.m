function openFiles(dirName)
%OPENFILES Open all directory files in editor.
% 
% OPENFILES(dirName)
% 
% dirName - String. Often pass pwd.

files = dir(dirName);
for i = 1:length(files)
	file = files(i);
	% Ignore . and ..
	if strcmp(file.name,'.')
		continue;
	end
	if strcmp(file.name,'..')
		continue;
	end
	open(file.name);
end
end