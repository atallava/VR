load data_12Jan.mat
% errors for reading1-11

bias = max(bias_readings);
gt = zeros(1,11); 
gt(1) = bias+0.3;
gt(2:6) = gt(1)-[1:5]*0.01;
gt(7:11) = gt(1)+[1:5]*0.01;

[nzeros,error,avg] = deal(zeros(1,11));
stepsize = zeros(1,10);
for i = 1:11
    var = strcat('reading',int2str(i));
    reading = eval(var);
    reading(reading == 0) = [];
    nzeros = 100-length(reading);
    avg(i) = mean(reading);
    error(i) = gt(i)-avg(i);
    if i == 1
        reference = avg(i);
    else
        stepsize(i-1) = reference-avg(i);
    end
end