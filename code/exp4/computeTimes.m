%% approx times at which each pose was collected
load data_Feb7
t = zeros(1,length(data));
for i = 1:length(data)
    m = length(data(i).u);
    if i == 1
        t(i) = m/30.0;
    else
        t(i) = t(i-1)+150.20+m/30.0;
    end
end
t = t/60;