function f1 = f1ScoreWrapper(~,params,scans)
% algoTemplate vacuous

targetLength = 0.61;
load target_lines_by_conf
nMin = params.nMin;
errorThresh = params.errorThresh;
% sorry, very ugly.
lineCandAlgo = @(x1,x2,x3,x4) lineCand(x1,x2,x3,x4,nMin,errorThresh); 
[nDetected,nCorrect,nTargets] = getPR(scans,targetLength,targetLinesByConf,lineCandAlgo);
p = sum(nCorrect)/sum(nDetected);
r = sum(nCorrect)/sum(nTargets);
f1 = 2*p*r/(p+r);
end