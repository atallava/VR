%% test how many samples are needed till an accurate histogram is obtained
load processed_data

ranges = obsArray(1,:,1);
samples = [10,20,50,100,200,300,400,500];
simscores = zeros(1,length(samples));
href = hist(ranges,rh.xCenters);

for i = 1:length(simscores)
    h{i} = hist(ranges(1:samples(i)),rh.xCenters);
    simscores(i) = histSimilarity(h{i},href);
end