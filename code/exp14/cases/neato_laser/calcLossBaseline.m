function loss = calcLossBaseline(dataReal,dataSim)
    %CALCLOSSBASELINE
    %
    % loss = CALCLOSSBASELINE(dataReal,dataSim)
    %
    % dataReal -
    % dataSim  -
    %
    % loss     -
    
debugFlag = false;

nSamples = length(dataReal);

rangesArrayReal = rangesArrayFromData(dataReal.Y);
rangesArraySim = rangesArrayFromData(dataSim.Y);

loss = rangesArrayReal(:)-rangesArraySim(:);
loss = loss.^2;
loss = sum(loss)/nSamples;
if isnan(loss)
    error('calcLossBaseline:invalidLoss','loss is NaN');
end
end