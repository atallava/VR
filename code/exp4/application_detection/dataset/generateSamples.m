%% generate a large number of configurations

n = 2.5e4;
t1 = tic();
count = 1;
while count < n
    try
        sampleVec(count) = sampleConfiguration();
        count = count+1;
    catch
        continue
    end
end
save('samples','sampleVec');
toc(t1)