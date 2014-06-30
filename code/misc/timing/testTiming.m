t1 = 1;
t2 = 0.6;
n = 5;
m = n; mArray = [];
while m > 0
    mArray = [mArray m];
    m = floor(m*t2/t1);
end