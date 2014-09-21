%% generate a large number of configurations

n = 2.5e4;
t1 = tic();
count = 0;
while count < n
    try
		count = count+1;
        sampleVec(count) = sampleConfiguration();
	catch
        continue
    end
end
save('samples','sampleVec');
toc(t1)