% time ksdensity
x = rand(1,1e4);
y = rand(1,1e4);

%% 
tVec = [];
nY = 5000;
n = [];
for i = 100:100:length(x)
    t1 = tic();
    tmp = ksdensity(y(1:nY),x(1:i),'bandwidth',0.001);
    n(end+1) = i;
    tVec(end+1) = toc(t1);
end

%% 
tVec = [];
nX = 1e3;
n = [];
for i = 1000:100:length(y)
    t1 = tic();
    tmp = ksdensity(y(1:i),x(1:nX),'bandwidth',0.001);
    n(end+1) = i;
    tVec(end+1) = toc(t1);
end

%% time pdist2
x1 = rand(1e4,1e3);
x2 = rand(1e4,1e3);

tVec = [];
nY = 50;
n = [];
for i = 100:100:size(x1,2)
    t1 = tic();
    tmp = pdist2(x2(1:nY,1:i),x1(1:nY,1:i));
    n(end+1) = i;
    tVec(end+1) = toc(t1);
end

%%
plot(n,tVec,'-.');


