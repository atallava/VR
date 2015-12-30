function [loss,algoParams] = calcLossAlgodev(dataReal,dataSim,algoObj,algoParamsSamples)
%CALCLOSSALGODEV
%
% [loss,algoParams] = CALCLOSSALGODEV(dataReal,dataSim,algoObj,algoParamsSamples)
%
% dataReal          -
% dataSim           -
% algoObj           - Function handle.
% algoParamsSamples - [nSamples,dimSamples] array.
%
% loss              - Scalar.
% algoParams        - Corresponding to max objDifference.

debugFlag = true;

paramNames = fieldnames(algoParamsSamples);
nAlgoParams = length(paramNames);
nSamples = length(algoParamsSamples);
algoObjDiffs = zeros(1,nSamples);

if debugFlag
    fprintf('calcLossAlgodev:Number of algo params: %d.\n',nAlgoParams);
    fprintf('calcLossAlgodev:Number of algo params samples: %d.\n',nSamples);
end
clockLocal = tic();
% loop over samples
for i = 1:nSamples
    if debugFlag
        fprintf('calcLossAlgodev:Algo params sample %d.\n',i);
    end
    algoParams = algoParamsSamples(i);
    objReal = algoObj(dataReal,algoParams);
    objSim = algoObj(dataSim,algoParams);
    algoObjDiffs(i) = abs(objReal-objSim);
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('calcLossAlgodev:Computation time: %.2fs.\n',tComp);
end

% set loss to max algo objective difference
[loss,id] = max(algoObjDiffs);
algoParams = algoParamsSamples(id);
end