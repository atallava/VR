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
dataSimLog = cell(1,nAlgos);
lossLog = zeros(1,nAlgos);
for i = 1:nAlgos
    dataReal = algosVars(i).dataReal;
    dataSim = genSimData(simModel,dataReal);
    loss = calcLossBaseline(dataReal,dataSim);
    risk = risk+loss;
    
    dataSimLog{i} = dataSim;
    lossLog(i) = loss;
end
end