function out = parsePingOutput(in)
n = length(in);
count = 1;
for i = 1:n
	str = in{i};
	posn = strfind(str,',');
	if isempty(posn)
		continue;
	end
	out(count) = str2num(str(posn+2:end-4));
	count = count+1;
end
end