% how performance varies with N
% should ideally do this on the test set

% load data
in.source = 'ascension-tracker'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '150831'; 
in.index = '';
fileName = buildDataFileName(in);
load(fileName);

%% specify sets of training data to use
xc = getHistogramBins(sensor);
[hArrayGt,~] = ranges2Histogram(ZHold,xc);
histDistance = @histDistanceMatch;
nRandomDraws = 5; % can't afford more

%% run parametric model
NTrainSetPReg = ceil(linspace(size(XHold,1)+10,size(XTrain,1),10));
errPReg = zeros(length(NTrainSetPReg),nRandomDraws);
bwXListPReg = {40 40};

clockLocal = tic();
for i = 1:length(NTrainSetPReg)
    N = NTrainSetPReg(i);
    for j = 1:nRandomDraws
        trainIdsSub = randsample(1:length(ZTrain),N);
        bwXListPReg = holdoutBwPRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance);
        [hPredArray,xc] = estimateHistogramGaussian(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XHold,sensor,bwXListPReg);
        [errPReg(i,j),~] = evalHPred(hArrayGt,hPredArray,histDistance);
    end
end
compTimePReg = toc(clockLocal);
fprintf('PReg estimation time: %.2fs.\n',compTimePReg);

%% dReg
NTrainSetDReg = ceil(linspace(size(XHold,1)+10,size(XTrain,1),10));
errDReg = zeros(length(NTrainSetDReg),nRandomDraws);
bwXDReg = 0.1;
bwZDReg = 0.05;

clockLocal = tic();
for i = 1:length(NTrainSetDReg)
    N = NTrainSetDReg(i);
    for j = 1:nRandomDraws
        trainIdsSub = randsample(1:length(ZTrain),N);
        [bwXDreg,bwZDReg] = holdoutBwDRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance);
        [hPredArray,xc] = estimateHistogram(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XHold,sensor,bwXDReg,bwZDReg);
        [errDReg(i,j),~] = evalHPred(hArrayGt,hPredArray,histDistance);
    end
end
compTimeDReg = toc(clockLocal);
fprintf('DReg estimation time: %.2fs.\n',compTimeDReg);

%% save to file
in.pre = '../data';
in.tag = 'exp11-sensor-modeling-perf-ntrain';
fileName = buildDataFileName(in);
save(fileName,...
    'sensor','histDistance','xc',...
    'NTrainSetPReg','bwXListPReg','errPReg','compTimePReg',...
    'NTrainSetDReg','bwXDReg','bwZDReg','errDReg','compTimeDReg');

%% plot
hf = figure; hold on;
errorbar(NTrainSetPReg,mean(errPReg,2),std(errPReg,0,2),'.-r');
hold on;
errorbar(NTrainSetDReg,mean(errDReg,2),std(errDReg,0,2),'.-b');
xlabel('training data');
ylabel('holdout error');
legend('parametric modeling','dReg');



