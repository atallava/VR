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

debugFlag = true;

risk = 0;
nAlgos = length(algosVars);
dataSimLog = cell(1,nAlgos);
lossLog = zeros(1,nAlgos);

if debugFlag
    fprintf('modelRiskBaseline:Number of algos: %d.\n',nAlgos);
end
clockLocal = tic();
for i = 1:nAlgos
    if debugFlag
        fprintf('modelRiskBaseline:Algo %d.\n',i);
    end
    dataReal = algosVars(i).dataReal;
    dataSim = genSimData(simModel,dataReal);
    loss = calcLossBaseline(dataReal,dataSim);
    risk = risk+loss;
    
    dataSimLog{i} = dataSim;
    lossLog(i) = loss;
end
tComp = toc(clockLocal);
if debugFlag
    fprintf('modelRiskBaseline:Computation time: %.2fs.\n',tComp);
end
end