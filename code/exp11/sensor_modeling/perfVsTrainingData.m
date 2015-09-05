% how does performance vary with training data

% load data
in.source = 'neato-laser'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '140906'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

%% specify sets of training data to use
xc = getHistogramBins(sensor);
hArrayGt = ranges2Histogram(ZTest,xc);
histDistance = @histDistanceMatch;
nRandomDraws = 5; % can't afford more

%% run parametric model
NTrainSetPReg = ceil(linspace(size(XTest,1)+10,min(size(XTrain,1),1e4),4));
errPReg = zeros(length(NTrainSetPReg),nRandomDraws);
bwXMu = [0.5053 0.3252];
bwXSigma = [0.2639 0.3514];
bwXListPReg = {bwXMu bwXSigma};

clockLocal = tic();
for i = 1:length(NTrainSetPReg)
    N = NTrainSetPReg(i);
    for j = 1:nRandomDraws
        trainIdsSub = randsample(1:length(ZTrain),N);
%         bwXListPReg = holdoutBwPRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance);
        [hPredArray,xc] = estimateHistogramGaussian(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XTest,sensor,bwXListPReg);
        [errPReg(i,j),~] = evalHPred(hArrayGt,hPredArray,histDistance);
    end
end
compTimePReg = toc(clockLocal);
fprintf('PReg estimation time: %.2fs.\n',compTimePReg);

%% dReg
NTrainSetDReg = ceil(linspace(size(XTest,1)+10,size(XTrain,1),4));
errDReg = zeros(length(NTrainSetDReg),nRandomDraws);
bwXDReg = [0.001 0.02];
bwZDReg = 1e-3;

clockLocal = tic();
for i = 1:length(NTrainSetDReg)
    N = NTrainSetDReg(i);
    for j = 1:nRandomDraws
        trainIdsSub = randsample(1:length(ZTrain),N);
%         [bwXDreg,bwZDReg] = holdoutBwDRegFn(XTrain,ZTrain,XHold,ZHold,sensor,histDistance);
        [hPredArray,xc] = estimateHistogram(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XTest,sensor,bwXDReg,bwZDReg);
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
ylabel('test error');
legend('pReg','dReg');



