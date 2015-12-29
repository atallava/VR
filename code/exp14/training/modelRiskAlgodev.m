function risk = modelRiskAlgodev(simModel,algosVars)
%MODELRISKALGODEV 
% 
% risk = MODELRISKALGODEV(simModel,algosVars)
% 
% simModel  - 
% algosVars - Struct array with fields
% ('dataReal','algoObj','paramsSamples')
% 
% risk      - Scalar.

debugFlag = false;

risk = 0;
nAlgos = length(algosVars);
dataSimLog = cell(1,nAlgos);
lossLog = zeros(1,nAlgos);

if debugFlag
    fprintf('modelRiskAlgodev:Number of algos: %d.\n',nAlgos);
end
clockLocal = tic();
for i = 1:nAlgos
    dataReal = algosVars(i).dataReal;
    algoObj = algosVars(i).algoObj;
    algoParamsSamples = algosVars(i).paramsSamples;
    dataSim = genSimData(simModel,dataReal);
    [loss,algoParams] = calcLossAlgodev(dataReal,dataSim,algoObj,algoParamsSamples);
    risk = risk+loss;
    
    dataSimLog{i} = dataSim;
    lossLog(i) = loss;
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('modelRiskAlgodev:Computation time: %.2fs.\n',tComp);
end
end