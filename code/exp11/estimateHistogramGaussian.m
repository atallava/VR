function [h,hCenters] = estimateHistogramGaussian(XTrain,ZTrain,X,laser)
    %ESTIMATEHISTOGRAMPARAM Use a parametric model to estimate distributions.
    %
    % [h,hCenters] = ESTIMATEHISTOGRAMPARAM(XTrain,ZTrain,X,laser,bwX)
    %
    % XTrain    - N x dimX array.
    % ZTrain    - length N cell array.
    % X         - Q x dimX array. Q is number of queries.
    % laser     - laserClass object.
    %
    % h         - Q x hCenters array of histogram values.
    % hCenters  - Histogram centers.
    
    N = length(ZTrain);
    Q = size(X,1);
   
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
            musTrain(i) = mean(ZTrain{i}); sigmasTrain = std(ZTrain{i});
        end
    end
    if isrow(musTrain); musTrain = musTrain'; end
    if isrow(sigmasTrain); sigmasTrain = sigmasTrain'; end

    % construct regressors for parameters
    % bandwidths taken from exp4/modeler
    in.XTrain = XTrain;
    in.YTrain = musTrain;
    in.kernelFn = @kernelRBF;
    in.kernelParams = struct('h',0.5053,'lambda',1.5539);
    muRegressor = locallyWeightedLinearRegressor(in);
    
    in.YTrain = sigmasTrain;
    in.kernelParams = struct('h',0.2639,'lambda',0.7509);
    sigmaRegressor = locallyWeightedLinearRegressor(in);
    
    % estimate parameters at query locations
    musQuery = muRegressor.predict(X);
    sigmasQuery = sigmaRegressor.predict(X);
    pZsQuery = zeros(1,Q); % no dropouts
    
    % construct histograms at query locations
    nHCenters = round(laser.maxRange/laser.rangeRes)+1; % number of histogram centers
    hCenters = linspace(0,laser.maxRange,nHCenters); % histogram centers
    h = zeros(Q,nHCenters);
    for i = 1:Q
        vec = [musQuery(i) sigmasQuery(i) pZsQuery(i)];
        tmpObj = normWithDrops(struct('vec',vec,'choice','params'));
        h(i,:) = tmpObj.snap2PMF(hCenters);
    end
end
