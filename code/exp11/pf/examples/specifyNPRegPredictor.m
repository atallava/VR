% load
fname = '../data/npreg_train_data_wide_corridor';
load(fname,'XTrain','ZTrain','sensor');

%% subsample training data
% if there's too much
maxData = 6000;
if length(ZTrain) > maxData
    ids = randsample(1:length(ZTrain),5000);
else
    ids = 1:length(ZTrain);
end
XTrain = XTrain(ids,:);
ZTrain = ZTrain(ids);

%% precompute observation histograms
nHCenters = round(sensor.maxRange/sensor.rangeRes)+1; % number of histogram centers
hCenters = linspace(0,sensor.maxRange,nHCenters); % histogram centers
hBinW = hCenters(2)-hCenters(1); % histogram bin width
k = 1; % fine-graining factor
nICenters = nHCenters*k; % number of integration centers
iBinW = hBinW/k; % integration bin width
iCenters = [0:nICenters-1]*iBinW-iBinW; % integration centers
trainHistEst = ranges2Histogram(ZTrain,iCenters)'; % [N,R]

%% build predictor
bwX = [0.001 0.0644];
npRegPredictor = @(X) estimateHistogramFast(XTrain,ZTrain,X,sensor,bwX,trainHistEst);

%% save
fnameOut = '../data/npreg_predictor';
save(fnameOut,'npRegPredictor','trainHistEst');
