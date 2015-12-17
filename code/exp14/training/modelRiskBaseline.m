function risk = modelRiskBaseline(simModel,algosVars)
%MODELRISKBASELINE
% 
% risk = MODELRISKBASELINE(simModel,algosVars)
% 
% simModel  - 
% algosVars - Struct array with fields
% ('realDataFName','algoObj','paramsSamples')
% 
% risk      - Scalar.

risk = 0;
nAlgos = length(algosVars);
simDataLog = cell(1,nAlgos);
lossLog = zeros(1,nAlgos);
for i = 1:nAlgos
    realData = load(algosVars(i).realDataFName);
    simData = genSimData(simModel,realData);
    loss = calcLossBaseline(realData,simData);
    risk = risk+loss;
    
    simDataLog{i} = simData;
    lossLog(i) = loss;
end
end