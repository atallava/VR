function loss = calcLossBaseline(dataReal,dataSim)
    %CALCLOSSBASELINE
    %
    % loss = CALCLOSSBASELINE(dataReal,dataSim)
    %
    % dataReal -
    % dataSim  -
    %
    % loss     -
    
debugFlag = true;

nData = length(dataReal.X);
if debugFlag
    fprintf('calcLossBaseline:nData: %d.\n',nData);
end

clockLocal = tic();
rangesArrayReal = rangesArrayFromData(dataReal.Y);
rangesArraySim = rangesArrayFromData(dataSim.Y);

loss = rangesArrayReal(:)-rangesArraySim(:);
loss = loss.^2;
loss = sum(loss)/nData;
tComp = clockLocal;
if debugFlag
    fprintf('calcLossBaseline:Computation time: %.2fs.\n',toc(clockLocal))
end
if isnan(loss)
    error('calcLossBaseline:invalidLoss','Loss is nan.');
end
if isinf(loss)
    %     error('calcLossBaseline:invalidLoss','Loss is inf.');
    loss = 1e6; % TODO: revert hack
end
end