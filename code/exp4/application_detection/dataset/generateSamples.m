%% generate a large number of configurations

n = 1e5;
t1 = tic();
count = 0;
while count < n
    if ~mod(count,100)
        fprintf('Sampling configuration %d.\n',count);
    end
    try
        count = count+1;
        sampleVec(count) = sampleConfiguration();
    catch
        continue
    end
end
save('samples','sampleVec');
fprintf('Computation took %.2fs.\n',toc(t1));