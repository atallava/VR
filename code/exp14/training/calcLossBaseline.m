function loss = calcLossBaseline(realData,simData)
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

nSamples = length(realData);
YReal = realData.Y;
YSim = simData.Y;

loss = YReal(:)-YSim(:);
loss = loss.^2;
loss = sum(loss)/nSamples;
end