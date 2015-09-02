function out = parseData(fname)
% fname is file name

fid = fopen(fname,'r');
line = fgetl(fid); % ignore first line
line = fgetl(fid);
out = struct('x',{},'y',{},'z',{}, ...
	'azimuth',{},'elevation',{},'roll',{},...
	'quality',{},'time',{});
lineNum = 1;
while ischar(line)
	data = strsplit(line);
	out(lineNum).x = str2num(data{4});
	out(lineNum).y = str2num(data{5});
	out(lineNum).z = str2num(data{6});
	out(lineNum).azimuth = str2num(data{7});
	out(lineNum).elevation = str2num(data{8});
	out(lineNum).roll = str2num(data{9});
	out(lineNum).quality = str2num(data{11});
	out(lineNum).time = str2num(data{12});
	lineNum = lineNum+1;
	line = fgetl(fid);
end

end