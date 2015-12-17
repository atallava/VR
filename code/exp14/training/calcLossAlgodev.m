function [loss,algoParams] = calcLossAlgodev(realData,simData,algoObj,algoParamsSamples)
%CALCLOSSALGODEV
%
% [loss,algoParams] = CALCLOSSALGODEV(realData,simData,algoObj,algoParamsSamples)
%
% realData          -
% simData           -
% algoObj           - Function handle.
% algoParamsSamples - [nSamples,dimSamples] array.
%
% loss              - Scalar.
% algoParams        - Corresponding to max objDifference.

debugFlag = false;

nSamples = size(algoParamsSamples,1);
algoObjDiffs = zeros(1,nSamples);

clockLocal = tic();
% loop over samples
for i = 1:nSamples
    algoParams = algoParamsSamples(i,:);
    objReal = algoObj(realData,algoParams);
    objSim = algoObj(simData,algoParams);
    algoObjDiffs(i) = abs(objReal-objSim);
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('calcLoss:Computation time: %.2fs.\n',tComp);
end

% set loss to max algo objective difference
[loss,id] = max(algoObjDiffs);
algoParams = algoParamsSamples(id,:);
end