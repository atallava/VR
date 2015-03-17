function [rH,hOpt] = kdeCV(data)
%KDECV Find optimal bw for KDE via CV.
% 
% hOpt = KDECV(data,h0)
% 
% data - Array of data.
% 
% hOpt    - Optimal bandwidth.

k = 10;
hMax = range(data);
hMin = range(data)/length(data);
nH = 10;
logH = linspace(log(hMin),log(hMax),nH);
hVec = exp(logH);

rH = zeros(size(hVec)); % risks
cvIds = crossvalind('Kfold',length(data),k);

for i = 1:nH
    h = hVec(i);
    r = zeros(1,k);
    nodes = min(data)-2*h:hMin:max(data)+2*h;
    nodeSpace = hMin;
    for j = 1:k
        testIds = cvIds == j;
        trainIds = cvIds ~= j;
        [f,~] = ksdensity(data(trainIds),nodes,'bandwidth',h);
        f2 = f.^2;
        P2 = sum(f2(1:end-1))*nodeSpace;
        [f,~] = ksdensity(data(trainIds),data(testIds),'bandwidth',h);
        r(j) = P2-2*mean(f);
    end
    rH(i) = mean(r);
end

[~,id] = min(rH);
hOpt = hVec(id);
end