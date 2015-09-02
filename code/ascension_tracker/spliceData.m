fname = 'data_tmp';
data = parseData(fname);

%%
leadTime = 5; % in s
recordTime = 5; % in s
load parameters_150831
n = 5;
leadCount = leadTime/freq;
recordCount = recordTime/freq;
dataset = cell(1,n);
for i = 1:n
	left = leadCount*i+recordCount*(i-1)+1;
	right = leadCount*i+recordCount*i;
	if right > length(data)
		right = length(data);
	end
	dataset{i} = data(left:right);
end