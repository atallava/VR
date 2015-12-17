function risk = modelRiskAlgodev(simModel,algosVars)
%MODELRISKALGODEV 
% 
% risk = MODELRISKALGODEV(simModel,algosVars)
% 
% simModel  - 
% algosVars - Struct array with fields
% ('realData','algoObj','paramsSamples')
% 
% risk      - Scalar.

risk = 0;
nAlgos = length(algosVars);
simDataLog = cell(1,nAlgos);
lossLog = zeros(1,nAlgos);
for i = 1:nAlgos
    realData = algosVars(i).realData;
    algoObj = algosVars(i).algoObj;
    algoParamsSamples = algosVars(i).paramsSamples;
    simData = genSimData(simModel,realData);
    [loss,algoParams] = calcLossAlgodev(realData,simData,algoObj,algoParamsSamples);
    risk = risk+loss;
    
    simDataLog{i} = simData;
    lossLog(i) = loss;
end
end