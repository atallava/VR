% how does performance vary with training data
% this is going to be a patchy script

% load data
in.source = 'neato-laser'; 
in.tag = 'exp11-sensor-modeling-dreg-input';
in.date = '140906'; 
in.index = '1';
fileName = buildDataFileName(in);
load(fileName);

%% specify sets of training data to use
[hArrayGt,~] = ranges2Histogram(ZTest,sensor);
histDistance = @histDistanceEuclidean;
nRandomDraws = 3; % can't afford more

%% run parametric model
NTrainSetGenCal = ceil(linspace(size(XTest,1)+10,min(size(XTrain,1),2e4),4)/2);
hPredCellGenCal = cell(1,nRandomDraws*length(NTrainSetGenCal));
errGenCal = zeros(length(NTrainSetGenCal),nRandomDraws);
count = 1;

clockLocal = tic();
for i = 4%1:length(NTrainSet)
    N = NTrainSetGenCal(i);
    if i < length(NTrainSetGenCal);
        jRange = 1:nRandomDraws;
    else 
        jRange = 1;
    end
    for j = jRange
        trainIdsSub = randsample(1:length(ZTrain),N);
        [hPredArray,xc] = estimateHistogramGaussian(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XTest,sensor);
        [errGenCal(i,j),~] = evalHPred(hArrayGt,hPredArray,histDistance);
        hPredCellGenCal{count} = hPredArray;
        count = count+1;
    end
end
compTimeGenCal = toc(clockLocal);
fprintf('Gen cal estimation time: %.2fs.\n',compTimeGenCal);

%% dReg
NTrainSetDReg = ceil(linspace(size(XTest,1)+10,size(XTrain,1),4));
hPredCellDReg = cell(1,nRandomDraws*length(NTrainSetDReg));
errDReg = zeros(1,length(NTrainSetDReg),nRandomDraws);
bwXDReg = [0.001 0.0644];
bwZDReg = 1e-3;
count = 1;

clockLocal = tic();
for i = 1:length(NTrainSetDReg)
    N = NTrainSetDReg(i);
    if i < length(NTrainSetDReg);
        jRange = 1:nRandomDraws;
    else 
        jRange = 1;
    end
    for j = 1:jRange
        trainIdsSub = randsample(1:length(ZTrain),N);
        [hPredArray,xc] = estimateHistogram(XTrain(trainIdsSub,:),ZTrain(trainIdsSub),XTest,sensor,bwXDReg,bwZDReg);
        [errDReg(i,j),~] = evalHPred(hArrayGt,hPredArray,histDistance);
        hPredCellDReg{count} = hPredArray;
        count = count+1;
    end
end
compTimeDReg = toc(clockLocal);
fprintf('DReg estimation time: %.2fs.\n',compTimeDReg);

%% save to file
in.pre = '../data';
in.tag = 'exp11-sensor-modeling-perf-ntrain';
fileName = buildDataFileName(in);
save(fileName,...
    'NTrainSet','hArrayGt','histDistance',...
    'NTrainSetGenCal','meanErrGenCal','hPredCellGenCal','compTimeGenCal',...
    'NTrainSetDReg','bwXDReg','bwZDReg','meanErrDReg','hPredCellDReg','compTimeDReg');

%% plot
hf = figure;
plot(NTrainSetDReg,errGenCal,'.-r');
plot(NTrainSetDReg,errDReg,'.-b');
xlabel('training data');
ylabel('average error');
legend('parametric modeling','dReg');



