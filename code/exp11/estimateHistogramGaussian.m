function [h,hCenters] = estimateHistogramGaussian(XTrain,ZTrain,X,sensor,bwXList)
    %ESTIMATEHISTOGRAMGAUSSIAN
    %
    % [h,hCenters] = ESTIMATEHISTOGRAMGAUSSIAN(XTrain,ZTrain,X,sensor,bwXList)
    %
    % XTrain   -
    % ZTrain   -
    % X        -
    % sensor   -
    % bwXList  -
    %
    % h        -
    % hCenters -
    
    N = length(ZTrain);
    Q = size(X,1);
    nHCenters = round(sensor.maxRange/sensor.rangeRes)+1; % number of histogram centers
    hCenters = linspace(0,sensor.maxRange,nHCenters); % histogram centers
    
    % estimate parameters at training locations
    musTrain = zeros(1,N);
    sigmasTrain = zeros(1,N);
    for i = 1:N
        M = length(ZTrain{i});
        if M == 0
            musTrain(i) = nan; sigmasTrain(i) = nan;
        elseif M == 1
            musTrain(i) = mean(ZTrain{i}); sigmasTrain(i) = nan;
        else
            musTrain(i) = mean(ZTrain{i}); sigmasTrain(i) = std(ZTrain{i});
        end
    end
    if isrow(musTrain); musTrain = musTrain'; end
    if isrow(sigmasTrain); sigmasTrain = sigmasTrain'; end
    
    % construct regressors for parameters
    % bandwidths taken from exp4/modeler
    in.XTrain = XTrain;
    in.YTrain = musTrain;
    in.kernelFn = @kernelRBF2;
    in.kernelParams = struct('h',bwXList{1});
    muRegressor = locallyWeightedLinearRegressor(in);
    
    in.YTrain = sigmasTrain;
    in.kernelParams = struct('h',bwXList{2});
    sigmaRegressor = locallyWeightedLinearRegressor(in);
    
    % estimate parameters at query locations
    musQuery = muRegressor.predict(X);
    sigmasQuery = sigmaRegressor.predict(X);
    pZsQuery = zeros(1,Q); % no dropouts
    
    % construct histograms at query locations
    h = zeros(Q,nHCenters);
    for i = 1:Q
        vec = [musQuery(i) sigmasQuery(i) pZsQuery(i)];
        tmpObj = normWithDrops(struct('vec',vec,'choice','params'));
        h(i,:) = tmpObj.snap2PMF(hCenters);
    end
end
