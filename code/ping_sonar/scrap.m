n = 1e3;
readings = cell(1,n);

%%
fread(pingObj,pingObj.BytesAvailable);
for i = 1:n
	readings{i} = fscanf(pingObj);
	pause(0.01);
end

%%
ranges = parsePingOutput(readings);
fname = 'data_3';
save(fname,'ranges');